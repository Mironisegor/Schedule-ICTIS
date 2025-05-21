//
//  SelectedGroupView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 30.01.2025.
//

import SwiftUI
import CoreData

struct SelectingVPKView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
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
                TextField("Поиск ВПК", text: $text)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .onChange(of: text) { oldValue, newValue in
                        searchTask?.cancel()
                        let task = DispatchWorkItem {
                            if !text.isEmpty {
                                serchGroupsVM.fetchGroups(group: text)
                            }
                            else {
                                serchGroupsVM.fetchGroups(group: "ВПК")
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
                            guard vm.errorInNetworkForSingleGroup == .noError else {
                                return
                            }
                            
                            vm.errorInNetworkForSingleGroup = nil
                            let formattedText = transformStringToFormat(text)
                            
                            do {
                                try saveGroup(name: formattedText)
                                saveScheduleForVpkToMemory(withName: formattedText)
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
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                )
            Spacer()
            if isLoading {
                LoadingView()
                Spacer()
            } else if networkMonitor.isConnected {
                ListOfGroupsView(vm: vm, serchGroupsVM: serchGroupsVM)
            } else {
                ConnectingToNetworkView()
            }
        }
        .padding(.horizontal, 10)
        .background(Color("background"))
        .onAppear {
            serchGroupsVM.fetchGroups(group: "ВПК")
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
    }
}

extension SelectingVPKView {
    func saveGroup(name: String) throws {
        let context = ClassProvider.shared.viewContext
        
        // Создаем fetch request с правильным типом
        let fetchRequest: NSFetchRequest<FavouriteVpkModel> = FavouriteVpkModel.all()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let existingGroups = try context.fetch(fetchRequest)
        guard existingGroups.isEmpty else { return }
        
        let newGroup = FavouriteVpkModel(context: context)
        newGroup.name = name
        try context.save()
    }
    
    func saveScheduleForVpkToMemory(withName name: String) {
        vm.fetchWeekForSingleGroup(groupName: name)
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
                print("✅ Успешно сохранено в CoreData")
            } catch {
                print("❌ Ошибка при сохранении в CoreData: \(error)")
            }
        }
    }
}
 
#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    @Previewable @StateObject var vm2 = NetworkMonitor()
    SelectingVPKView(vm: vm, networkMonitor: vm2)
}
