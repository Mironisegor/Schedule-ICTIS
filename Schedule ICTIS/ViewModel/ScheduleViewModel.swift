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
    
    @Published var nameGroups: [String] = []
    @Published var numbersNTMLGroups: [String] = []
    @Published var classesGroups: [[ClassInfo]] = []
    
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
    @Published var selectedIndex: Int = 1
    @Published var week: Int = 0
    
    @Published var isFirstStartOffApp = true
    @Published var isShowingAlertForIncorrectGroup: Bool = false
    @Published var errorInNetwork: NetworkError?
    @Published var isLoading: Bool = false
    @Published var isNewGroup: Bool = false
    
    //Groups
    @Published var groups: [Choice] = []
    //VPK
    @Published var vpks: [[String]] = []
    @Published var vpkHTML: String = ""
    @Published var vpk: String = ""
    @Published var weekScheduleVPK: Table = Table(
        type: "",
        name: "",
        week: 0,
        group: "",
        table: [[]],
        link: ""
    )
    
    //MARK: Methods    
    func fetchWeekSchedule(isOtherWeek: Bool = false) {
        isLoading = true
        Task {
            do {
                var updatedClassesGroups: [[ClassInfo]] = Array(repeating: [], count: 6) // 6 дней (пн-сб)
                
                if isOtherWeek {
                    for groupHTML in numbersNTMLGroups {
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
                    for groupName in nameGroups {
                        let schedule = try await NetworkManager.shared.getSchedule(groupName)
                        let numberHTML = schedule.table.group
                        self.numbersNTMLGroups.append(numberHTML)
                        let table = schedule.table.table
                        self.week = schedule.table.week
                        
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
                if let error = error as? NetworkError {
                    switch error {
                    case .invalidResponse:
                        errorInNetwork = .invalidResponse
                    case .invalidData:
                        errorInNetwork = .invalidData
                        self.isShowingAlertForIncorrectGroup = true
                    default:
                        print("Неизвестная ошибка: \(error)")
                    }
                    isLoading = false
                    print("Есть ошибка: \(error)")
                }
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
    
    func updateArrayOfGroups() {
        self.nameGroups.removeAll()
        self.numbersNTMLGroups.removeAll()
        let group1 = UserDefaults.standard.string(forKey: "group")
        let group2 = UserDefaults.standard.string(forKey: "group2")
        let group3 = UserDefaults.standard.string(forKey: "group3")
        let vpk1 = UserDefaults.standard.string(forKey: "vpk1")
        let vpk2 = UserDefaults.standard.string(forKey: "vpk2")
        let vpk3 = UserDefaults.standard.string(forKey: "vpk3")
        if let nameGroup1 = group1, nameGroup1 != "" {
            self.nameGroups.append(nameGroup1)
        }
        if let nameGroup2 = group2, nameGroup2 != ""  {
            self.nameGroups.append(nameGroup2)
        }
        if let nameGroup3 = group3, nameGroup3 != "" {
            self.nameGroups.append(nameGroup3)
        }
        if let nameVPK1 = vpk1, nameVPK1 != "" {
            self.nameGroups.append(nameVPK1)
        }
        if let nameVPK2 = vpk2, nameVPK2 != "" {
            self.nameGroups.append(nameVPK2)
        }
        if let nameVPK3 = vpk3, nameVPK3 != "" {
            self.nameGroups.append(nameVPK3)
        }
    }
}
