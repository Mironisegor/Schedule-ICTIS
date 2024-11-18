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
    @Published var selectedIndex: Int = 0
    
    init() {
        fetchWeekSchedule()
    }
    
    //MARK: Methods
    func fetchWeekSchedule(){
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
    
    func updateSelectedDayIndex(_ date: Date) {
        switch date.format("E") {
        case "Пн":
            selectedIndex = 1
        case "Вт":
            selectedIndex = 2
        case "Ср":
            selectedIndex = 3
        case "Чт":
            selectedIndex = 4
        case "Пт":
            selectedIndex = 5
        case "Сб":
            selectedIndex = 6
        default:
            selectedIndex = 7
        }
        print(selectedIndex)
    }
    
    func updateSelectedIndex(_ index: Int) {
        selectedIndex = index
        print(selectedIndex)
    }
}
