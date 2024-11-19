//
//  ViewModel.swift
//  NewsApp
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation

@MainActor
final class ViewModel: ObservableObject {
    //MARK: Properties
    @Published var weekSchedule: [Table] = []
    @Published var selectedDay: Date = Date()
    @Published var selectedIndex: Int = 1
    
    init() {
        fetchWeekSchedule()
    }
    
    //MARK: Methods
    func fetchWeekSchedule() {
        Task {
            do {
                let schedule = try await NetworkManager.shared.getSchedule()
                weekSchedule = [schedule.table]
            }
            catch {
                if let error = error as? NetworkError {
                    print(error)
                }
            }
        }
    }
    
    func getSelectedDaySchedule(for date: Date) -> [String]? {
        guard let week = weekSchedule.first else { return nil }
        let dayIndex = week.table.firstIndex { $0[0].contains(date.format("dd MMMM")) }
        return dayIndex.flatMap { week.table[$0] }
    }
    
    func updateSelectedDayIndex(_ date: Date) {
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
    
    func updateSelectedIndex(_ index: Int) {
        selectedIndex = index
        print(selectedIndex)
    }
}
