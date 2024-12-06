//
//  ViewModel.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation

@MainActor
final class ViewModel: ObservableObject {
    //MARK: Properties
    @Published var weekSchedule: Table = Table(
        type: "",
        name: "",
        week: 0,
        group: "",
        table: [[]],
        link: ""
    )
    @Published var selectedDay: Date = .init()
    @Published var selectedIndex: Int = 1
    @Published var classes: [[String]] = []
    @Published var week: Int = 0
    @Published var numOfGroup: String = ""
    @Published var isFirstStartOffApp = true
    
    //MARK: Methods
    func fetchWeekSchedule(_ group: String = "new week", _ num: Int = 0) {
        Task {
            do {
                let schedule: Schedule
                if (group == "new week") {
                    schedule = try await NetworkManager.shared.getScheduleForOtherWeek(week + num, numOfGroup)
                }
                else{
                    schedule = try await NetworkManager.shared.getSchedule(group)
                }
                weekSchedule = schedule.table
                week = weekSchedule.week
                numOfGroup = weekSchedule.group
                print(week)
                print(numOfGroup)
                classes = weekSchedule.table
            }
            catch {
                if let error = error as? NetworkError {
                    print(error)
                }
            }
        }
    }
    
    func updateSelectedDayIndex(_ date: Date) {
        selectedDay = date
        switch date.format("E") {
        case "Пн":
            selectedIndex = 2
        case "Вт":
            selectedIndex = 3
        case "Ср":
            selectedIndex = 4
        case "Чт":
            selectedIndex = 5
        case "Пт":
            selectedIndex = 6
        case "Сб":
            selectedIndex = 7
        default:
            selectedIndex = 8
        }
        print(selectedIndex)
    }
    
}
