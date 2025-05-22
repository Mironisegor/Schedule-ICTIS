//
//  SelectedGroupView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 30.01.2025.
//

import SwiftUI
import CoreData

struct SelectingGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State var text: String = ""
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    @State private var isLoading = false
    @State private var searchTask: DispatchWorkItem?
    @StateObject private var serchGroupsVM = SearchGroupsViewModel()
    var provider = ClassProvider.shared
    var body: some View {
        VStack {
            HStack (spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                    .padding(.leading, 12)
                    .padding(.trailing, 7)
                TextField("Поиск группы", text: $text)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .onChange(of: text) { oldValue, newValue in
                        searchTask?.cancel()
                        let task = DispatchWorkItem {
                            if !text.isEmpty {
                                serchGroupsVM.fetchGroups(group: text)
                            }
                            else {
                                serchGroupsVM.fetchGroups(group: "кт")
                            }
                        }
                        searchTask = task
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
                    }
                    .onSubmit {
                        self.isFocused = false
                        guard !text.isEmpty else { return }
                        
                        self.isLoading = true
                        vm.fetchWeekForSingleGroup(groupName: text)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if vm.errorInNetworkForSingleGroup != .noError {
                                return
                            }
                            
                            vm.errorInNetworkForSingleGroup = nil
                            let formattedText = transformStringToFormat(text)
                            
                            do {
                                try saveGroup(name: formattedText)
                                saveScheduleForGroupToMemory(withName: formattedText)
                                vm.nameToHtml[formattedText] = ""
                                vm.addGroupToFilteringArray(group: formattedText)
                                vm.fetchWeekSchedule()
                                self.isLoading = false
                                self.text = ""
                                dismiss()
                            } catch {
                                print("Ошибка сохранения: \(error.localizedDescription)")
                                vm.isShowingAlertForIncorrectSingleGroup = true
                            }
                        }
                    }
                    .submitLabel(.done)
                if isFocused {
                    Button {
                        self.text = ""
                        self.isFocused = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.trailing, 20)
                            .offset(x: 10)
                            .foregroundColor(.gray)
                            .background(
                            )
                        }
                }
            }
            .frame(height: 40)
            .background (
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            Spacer()
            if isLoading {
                LoadingView()
                Spacer()
            } else if networkMonitor.isConnected {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(serchGroupsVM.groups) { item in
                        if item.name.starts(with: "КТ") { //Отображаем только группы(без аудиторий и преподавателей)
                            VStack {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("customGray1"))
                                    .padding(.horizontal, 10)
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.black)
                                        .font(.custom("Montserrat-SemiBold", fixedSize: 15))
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                .padding(.top, 2)
                                .padding(.bottom, 2)
                                .frame(width: UIScreen.main.bounds.width, height: 30)
                                .background(Color("background"))
                                .onTapGesture {
                                    do {
                                        try saveGroup(name: item.name)
                                        saveScheduleForGroupToMemory(withName: item.name)
                                        vm.nameToHtml[item.name] = ""
                                        vm.addGroupToFilteringArray(group: item.name)
                                        if vm.filteringGroups.count == 2 {
                                            vm.showOnlyChoosenGroup = vm.filteringGroups[1]
                                        }
                                        vm.fetchWeekSchedule()
                                        self.isLoading = false
                                        self.text = ""
                                        dismiss()
                                    } catch {
                                        print("Ошибка сохранения: \(error.localizedDescription)")
                                        vm.isShowingAlertForIncorrectGroup = true
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                NetworkErrorView(message: "Восстановите подключение к интернету чтобы мы смогли загрузить список групп")
            }
        }
        .padding(.horizontal, 10)
        .background(Color("background"))
        .onAppear {
            serchGroupsVM.fetchGroups(group: "кт")
        }
        .navigationBarBackButtonHidden(true) // Скрываем стандартную кнопку "Назад"
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .gesture(
            DragGesture().onEnded { value in
                if value.startLocation.x < 50 && value.translation.width > 80 {
                    dismiss()
                }
            }
        )
    }
}

extension SelectingGroupView {
    func saveGroup(name: String) throws {
        let context = ClassProvider.shared.viewContext
        
        // Создаем fetch request с правильным типом
        let fetchRequest: NSFetchRequest<FavouriteGroupModel> = FavouriteGroupModel.all()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let existingGroups = try context.fetch(fetchRequest)
        guard existingGroups.isEmpty else { return }
        
        let newGroup = FavouriteGroupModel(context: context)
        newGroup.name = name
        try context.save()
    }
    
    func saveScheduleForGroupToMemory(withName name: String) {
        vm.fetchWeekForSingleGroup(groupName: name)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var indexOfTheDay: Int16 = 0
            let context = provider.newContext // Создаем новый контекст
            
            context.perform {
                for dayIndex in 0..<self.vm.classesForSingleGroup.count {
                    let classesForDay = self.vm.classesForSingleGroup[dayIndex]
                    
                    // Проходим по всем занятиям текущего дня
                    for classInfo in classesForDay {
                        let newClass = JsonClassModel(context: context)
                        
                        // Заполняем атрибуты
                        newClass.name = classInfo.subject
                        newClass.group = classInfo.group
                        newClass.time = classInfo.time
                        newClass.day = indexOfTheDay
                        newClass.week = Int16(vm.weekForSingleGroup)
                    }
                    indexOfTheDay += 1
                }
                
                // Сохраняем изменения в CoreData
                do {
                    try self.provider.persist(in: context)
                    print("✅ Избранная группа успешно сохранена в CoreData")
                } catch {
                    print("❌ Возникла ошибка при сохранении избранной группы в CoreData: \(error)")
                }
            
                let fetchRequest: NSFetchRequest<JsonClassModel> = JsonClassModel.all()
                do {
                    let results = try context.fetch(fetchRequest)
                    for group in results {
                        print(group.group)
                    }
                } catch {
                    print("Ошибка при выполнении fetch-запроса: \(error)")
                }
            }
        }
    }
}
 
#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    @Previewable @StateObject var vm2 = NetworkMonitor()
    SelectingGroupView(vm: vm, networkMonitor: vm2)
}
