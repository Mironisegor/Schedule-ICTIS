//
//  ViewModel.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation
import SwiftUICore

@MainActor
final class ScheduleViewModel: ObservableObject {
    //MARK: Properties
    @Published var classesForSingleGroup: [[ClassInfo]] = []
    @Published var weekForSingleGroup = 0
    @Published var nameToHtml: [String : String] = [:]
    @Published var classesGroups: [[ClassInfo]] = []
    @Published var searchingGroup = ""
    @Published var filteringGroups: [String] = ["Все"]
    @Published var showOnlyChoosenGroup: String = "Все"
    
    //Schedule
    @Published var weekScheduleGroup: Table = Table(
        type: "",
        name: "",
        week: 0,
        group: "",
        table: [[]],
        link: ""
    )
    @Published var selectedDay: Date = .init()
    @Published var selectedIndex: Int = 0
    @Published var week: Int = 0
    
    @Published var isFirstStartOffApp = true
    @Published var isShowingAlertForIncorrectGroup: Bool = false
    @Published var errorInNetwork: NetworkError?
    @Published var isLoading: Bool = false
    @Published var isNewGroup: Bool = false
    
    //MARK: Methods    
    func fetchWeekSchedule(isOtherWeek: Bool = false) {
        isLoading = true
        Task {
            do {
                var updatedClassesGroups: [[ClassInfo]] = Array(repeating: [], count: 6) // 6 дней (пн-сб)
                
                // Если другая неделя, запрашиваем расписание по неделе и номеру группу(в HTML формате)
                if isOtherWeek {
                    let groupHTMLs = Array(self.nameToHtml.values)
                    for groupHTML in groupHTMLs {
                        let schedule = try await NetworkManager.shared.getScheduleForOtherWeek(self.week, groupHTML)
                        let table = schedule.table.table
                        let nameOfGroup = schedule.table.name
                        
                        // Преобразуем данные в формат ClassInfo
                        for (dayIndex, day) in table[2...].enumerated() { // Пропускаем первые две строки (заголовки)
                            for (timeIndex, subject) in day.enumerated() {
                                if !subject.isEmpty && timeIndex > 0 { // Пропускаем первый столбец (день и дату)
                                    let time = table[1][timeIndex] // Время берем из второй строки
                                    let classInfo = ClassInfo(subject: subject, group: nameOfGroup, time: time)
                                    updatedClassesGroups[dayIndex].append(classInfo)
                                }
                            }
                        }
                    }
                } else {
                    let groupNames = Array(self.nameToHtml.keys)
                    for groupName in groupNames {
                        let schedule = try await NetworkManager.shared.getSchedule(groupName)
                        let numberHTML = schedule.table.group
                        self.nameToHtml[groupName] = numberHTML
                        let table = schedule.table.table
                        self.week = schedule.table.week
//                        print("Группа: \(schedule.table.name), неделя: \(schedule.table.week)")
//                        print(table)
                        
                        // Преобразуем данные в формат ClassInfo
                        for (dayIndex, day) in table[2...].enumerated() { // Пропускаем первые две строки (заголовки)
                            for (timeIndex, subject) in day.enumerated() {
                                if !subject.isEmpty && timeIndex > 0 { // Пропускаем первый столбец (день и дату)
                                    let time = table[1][timeIndex] // Время берем из второй строки
                                    let classInfo = ClassInfo(subject: subject, group: groupName, time: time)
                                    updatedClassesGroups[dayIndex].append(classInfo)
                                }
                            }
                        }
                    }
                }
                
                // Обновляем данные
                self.classesGroups = updatedClassesGroups
                self.isFirstStartOffApp = false
                self.isShowingAlertForIncorrectGroup = false
                self.isLoading = false
                self.errorInNetwork = .noError
                
                // Сортируем по времени
                self.sortClassesByTime()
            } catch {
                if let urlError = error as? URLError, urlError.code == .timedOut {
                    errorInNetwork = .timeout
                    print("Ошибка: превышено время ожидания ответа от сервера")
                } else if let error = error as? NetworkError {
                    switch error {
                    case .invalidResponse:
                        errorInNetwork = .invalidResponse
                    case .invalidData:
                        errorInNetwork = .invalidData
                        self.isShowingAlertForIncorrectGroup = true
                    default:
                        print("Неизвестная ошибка: \(error)")
                    }
                    print("Есть ошибка: \(error)")
                }
                isLoading = false
            }
        }
    }
    
    func fetchWeekForSingleGroup(groupName name: String) {
        isLoading = true
        Task {
            do {
                var singleSchedule: [[ClassInfo]] = Array(repeating: [], count: 6) // 6 дней (пн-сб)
                let schedule = try await NetworkManager.shared.getSchedule(name)
                let table = schedule.table.table
                let groupName = schedule.table.name
                self.weekForSingleGroup = schedule.table.week
                    
                // Преобразуем данные в формат ClassInfo
                for (dayIndex, day) in table[2...].enumerated() { // Пропускаем первые две строки (заголовки)
                    for (timeIndex, subject) in day.enumerated() {
                        if !subject.isEmpty && timeIndex > 0 { // Пропускаем первый столбец (день и дату)
                            let time = table[1][timeIndex] // Время берем из второй строки
                            let classInfo = ClassInfo(subject: subject, group: groupName, time: time)
                            singleSchedule[dayIndex].append(classInfo)
                        }
                    }
                }
                
                // Обновляем данные
                self.classesForSingleGroup = singleSchedule
                self.isShowingAlertForIncorrectGroup = false
                self.isLoading = false
                self.errorInNetwork = .noError
                
            } catch {
                if let urlError = error as? URLError, urlError.code == .timedOut {
                    errorInNetwork = .timeout
                    print("Ошибка: превышено время ожидания ответа от сервера")
                } else if let error = error as? NetworkError {
                    switch error {
                    case .invalidResponse:
                        errorInNetwork = .invalidResponse
                    case .invalidData:
                        errorInNetwork = .invalidData
                        print("FetchSingle: InvalidData")
                        self.isShowingAlertForIncorrectGroup = true
                    default:
                        print("Неизвестная ошибка: \(error)")
                    }
                    print("Есть ошибка: \(error)")
                }
                isLoading = false
            }
        }
    }
    
    func updateSelectedDayIndex() {
        switch selectedDay.format("E") {
        case "Пн":
            selectedIndex = 0
        case "Вт":
            selectedIndex = 1
        case "Ср":
            selectedIndex = 2
        case "Чт":
            selectedIndex = 3
        case "Пт":
            selectedIndex = 4
        case "Сб":
            selectedIndex = 5
        default:
            selectedIndex = 6
        }
    }
    
    private func parseTime(_ timeString: String) -> Int {
        // Разделяем строку по дефису и берем первую часть (время начала)
        let startTimeString = timeString.components(separatedBy: "-").first ?? ""
        
        // Разделяем время на часы и минуты
        let components = startTimeString.components(separatedBy: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return 0 // В случае ошибки возвращаем 0
        }
        
        // Преобразуем время в минуты с начала дня
        return hours * 60 + minutes
    }
    
    // Method for sorting classes by time
    private func sortClassesByTime() {
        // Проходим по каждому дню (подмассиву) в classesGroups
        for dayIndex in 0..<classesGroups.count {
            // Сортируем подмассив по времени начала пары
            classesGroups[dayIndex].sort { class1, class2 in
                let time1 = parseTime(class1.time) // Время начала первой пары
                let time2 = parseTime(class2.time) // Время начала второй пары
                return time1 < time2 // Сортируем по возрастанию
            }
        }
    }
    
    func removeFromSchedule(group: String) {
        self.nameToHtml[group] = nil
        
        for i in classesGroups.indices {
            // Сначала находим индексы элементов для удаления
            let indicesToRemove = classesGroups[i].indices.filter { j in
                classesGroups[i][j].group.lowercased() == group.lowercased()
            }
            
            // Удаляем элементы в обратном порядке, чтобы индексы оставались корректными
            for j in indicesToRemove.reversed() {
                classesGroups[i].remove(at: j)
            }
        }
    }
    
    func updateFilteringGroups() {
        self.filteringGroups = ["Все"]
        let keys = self.nameToHtml.keys
        print(keys)
        self.filteringGroups.append(contentsOf: keys)
    }
}
