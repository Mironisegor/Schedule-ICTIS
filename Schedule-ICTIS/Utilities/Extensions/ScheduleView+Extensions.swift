//
//  ScheduleView+Extensions.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 04.04.2025.
//

import SwiftUI
import CoreData

extension ScheduleView {
    // Удаляем пары добавленные пользователем, если сегодня понедельник
    func deleteClassesFormCoreDataIfMonday() {
        let timeManager = TimeService.shared
        let today = timeManager.currentTime
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: today)
        
        if weekday == 6 {
            for _class in classes {
                if _class.day < today {
                    do {
                        try provider.delete(_class, in: provider.viewContext)
                    } catch {
                        print("❌ - Ошибка при удалении, добавленных пользователем пар: \(error)")
                    }
                }
            }
        }
    }
    
    func saveGroupsToMemory() {
        var indexOfTheDay: Int16 = 0
        let context = provider.newContext // Создаем новый контекст
        
        context.perform {
            for dayIndex in 0..<self.vm.classesGroups.count {
                let classesForDay = self.vm.classesGroups[dayIndex]
                
                // Проходим по всем занятиям текущего дня
                for classInfo in classesForDay {
                    let newClass = JsonClassModel(context: context)
                    
                    // Заполняем атрибуты
                    newClass.name = classInfo.subject
                    newClass.group = classInfo.group
                    newClass.time = classInfo.time
                    newClass.day = indexOfTheDay
                    newClass.week = Int16(vm.week)
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
    
    @MainActor
    func deleteAllJsonClassModelsSync() throws {
        let context = provider.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = JsonClassModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(deleteRequest)
        try context.save()
        print("✅ Все объекты JsonClassModel успешно удалены")
    }
    
    func checkSavingOncePerDay() {
        let timeManager = TimeService.shared
        let today = timeManager.currentTime
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: today) // Начало текущего дня
        
        // Получаем дату последнего выполнения из UserDefaults
        let lastCheckDate = UserDefaults.standard.object(forKey: "LastSaving") as? Date ?? .distantPast
        let lastCheckStart = calendar.startOfDay(for: lastCheckDate)
    
        print("Дата последнего сохранения расписания в CoreData: \(lastCheckDate)")
        
        // Проверяем, был ли уже выполнен код сегодня
        if lastCheckStart < todayStart && networkMonitor.isConnected {
            print("✅ Интернет есть, сохранение пар в CoreData")
            vm.fetchWeekSchedule()
            do {
                try deleteAllJsonClassModelsSync()
            } catch {
                print("Ошибка при удалении: \(error)")
                return
            }
            saveGroupsToMemory()
            
            // Сохраняем текущую дату как дату последнего выполнения
            UserDefaults.standard.set(today, forKey: "LastSaving")
        }
    }
}
