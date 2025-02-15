//
//  ViewModel.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation

@MainActor
final class ScheduleViewModel: ObservableObject {
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
    @Published var isShowingAlertForIncorrectGroup: Bool = false
    @Published var errorInNetwork: NetworkError?
    @Published var isLoading: Bool = false
    @Published var group: String = ""
    @Published var isNewGroup: Bool = false
    
    //MARK: Methods
    func fetchWeekSchedule(group: String = "default", isOtherWeek: Bool = false) {
        isLoading = true
        Task {
            do {
                var schedule: Schedule
                // В этот if мы заходим только если пользователь перелистывает недели и нам известы номер группы(в html формате) и номер недели, которая показывается пользователю
                if (isOtherWeek || !isFirstStartOffApp) && (group == "default") {
                    schedule = try await NetworkManager.shared.getScheduleForOtherWeek(self.week, self.numOfGroup)
                }
                // В else мы заходим в том случае, если не знаем номер недели, которую нужно отобразить и номер группы(в html формате)
                else  {
                    schedule = try await NetworkManager.shared.getSchedule(group)
                    if (!self.isFirstStartOffApp) {
                        self.isNewGroup = true
                    }
                    self.selectedDay = .init()
                }
                self.weekSchedule = schedule.table
                self.week = weekSchedule.week
                self.numOfGroup = weekSchedule.group
                self.classes = weekSchedule.table
                self.isFirstStartOffApp = false
                self.isShowingAlertForIncorrectGroup = false
                self.isLoading = false
                self.errorInNetwork = .noError
                
            }
            catch {
                if let error = error as? NetworkError {
                    switch (error) {
                    case .invalidResponse:
                        errorInNetwork = .invalidResponse
                    case .invalidData:
                        errorInNetwork = .invalidData
                        self.isShowingAlertForIncorrectGroup = true
                    default:
                        print(2)
                    }
                    isLoading = false
                    print(error)
                }
            }
        }
    }
    
    func updateSelectedDayIndex() {
        switch selectedDay.format("E") {
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
    }
    
}
