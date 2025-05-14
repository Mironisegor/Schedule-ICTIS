//
//  ListOfGroupsView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.03.2025.
//

import SwiftUI
import CoreData

struct ListOfGroupsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var serchGroupsVM: SearchGroupsViewModel
    var provider = ClassProvider.shared
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(serchGroupsVM.groups) { item in
                if item.name.starts(with: "ВПК") || item.name.starts(with: "мВПК") {
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
                                saveScheduleForVpkToMemory(withName: item.name)
                                vm.nameToHtml[item.name] = ""
                                vm.updateFilteringGroups()
                                vm.fetchWeekSchedule()
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
    }
}

extension ListOfGroupsView {
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
