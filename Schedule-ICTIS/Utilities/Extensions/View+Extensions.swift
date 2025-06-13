//
//  View+Extensions.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 15.11.2024.
//

import SwiftUI
import CoreData

extension View {
    
    func transformStringToFormat(_ input: String) -> String {
        var result = input
        
        // Условие 1: начинается с "кт"
        if result.lowercased().hasPrefix("кт") {
            result = result.lowercased()
            let firstTwo = String(result.prefix(2)).uppercased()
            let rest = String(result.dropFirst(2))
            result = firstTwo + rest
            return result
        }
        
        // Условие 2: содержит "впк"
        if result.lowercased().contains("впк") {
            result = result.lowercased()
            result = result.replacingOccurrences(of: "впк", with: "ВПК")
            return result
        }
        
        // Условие 3: содержит "мвпк"
        if result.lowercased().contains("мвпк") {
            result = result.lowercased()
            result = result.replacingOccurrences(of: "впк", with: "ВПК")
            return result
        }
        
        return result
    }
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func isDateInCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let timeManager = TimeService.shared
        let currentDate = timeManager.currentTime
        
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        let dateMonth = calendar.component(.month, from: date)
        let dateYear = calendar.component(.year, from: date)
        
        return currentMonth == dateMonth && currentYear == dateYear
    }
    
    func isSameWeek(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.compare(date1, to: date2, toGranularity: .weekOfYear) == .orderedSame
    }
    
    func weeksBetween(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: startDate)
        let startOfEndDate = calendar.startOfDay(for: endDate)
        
        let weekForDate1 = calendar.dateInterval(of: .weekOfMonth, for: startOfFirstDate)
        let weekForDate2 = calendar.dateInterval(of: .weekOfMonth, for: startOfEndDate)
        
        guard let startOfWeek1 = weekForDate1?.start else {
            return 0
        }
        
        guard let startOfWeek2 = weekForDate2?.start else {
            return 0
        }
        
        let components = calendar.dateComponents([.day], from: startOfWeek1, to: startOfWeek2)
        let daysDifference = components.day ?? 0
        return Int(ceil(Double(abs(daysDifference)) / 7.0))
    }
    
    func convertTimeString(_ input: String) -> [String] {
        let parts = input.split(separator: "-")
        if let firstPart = parts.first, let lastPart = parts.last {
            return [String(firstPart), String(lastPart)]
        } else {
            return []
        }
    }
    
    func getColorForClass(_ str: String) -> Color {
        if (str.contains("LMS")) {
            return Color("blueForOnline")
        }
        else if (str.contains("ВПК")) {
            return Color("turquoise")
        }
        else {
            return Color("greenForOffline")
        }
    }
    
    func hoursMinutesAreEqual(date1: Date, isEqualTo date2: Date) -> Bool {
        let calendar = Calendar.current
        
        let components1 = calendar.dateComponents([.day, .hour, .minute], from: date1)
        let components2 = calendar.dateComponents([.day, .hour, .minute], from: date2)
        
        return components1.day == components2.day && components1.hour == components2.hour && components1.minute == components2.minute
    }
    
    // MARK: ScheduleView
    func daysAreEqual(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year &&
               components1.month == components2.month &&
               components1.day == components2.day
    }
    
    func onlineOrNot(_ str: String) -> Color {
        if (str == "Онлайн") {
            return Color("blueForOnline")
        }
        else {
            return Color("greenForOffline")
        }
    }
    
    func getSubjectName(_ subject: String, _ professor: String, _ auditory: String) -> String {
        return "\(subject) \(professor) \(auditory)"
    }
    
    func getTimeString(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        guard let hour = components.hour, let minute = components.minute else {
            return "Invalid time"
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    func checkStartTimeLessThenEndTime(_ startTime: Date, _ endTime: Date) -> Bool {
        let calendar = Calendar.current
        
        let firstComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let secondComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        guard let startHours = firstComponents.hour, let startMinutes = firstComponents.minute else {
            return false
        }
        guard let endHours = secondComponents.hour, let endMinutes = secondComponents.minute else {
            return false
        }
        
        print("\(startHours) - \(endHours)")
        print("\(startMinutes) - \(endMinutes)")
        if Int(startHours) > Int(endHours) {
            return false
        }
        else if startHours == endHours {
            if startMinutes < endMinutes {
                return true
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }
}

extension WeekTabView {
    func updateWeekScreenViewForNewGroup() {
        let timeManager = TimeService.shared
        vm.updateSelectedDayIndex()
        if weekSlider.isEmpty {
            let currentWeek = timeManager.currentTime.fetchWeek()
                
            if let firstDate = currentWeek.first?.date {
                weekSlider.append(firstDate.createPrevioustWeek())
            }
                
            weekSlider.append(currentWeek)
                
            if let lastDate = currentWeek.last?.date {
                weekSlider.append(lastDate.createNextWeek())
            }
        }
    }
}

extension WeekViewForWeek {
    func paginateWeek() {
        let timeManager = TimeService.shared
        let calendar = Calendar.current
        let groupsKeys = Array (vm.nameToHtml.keys)
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date,
                currentWeekIndex == 0 {
                vm.week -= 1
                if !groupsKeys.isEmpty {
                    vm.fetchWeekSchedule(isOtherWeek: true)
                }
                if UserDefaults.standard.string(forKey: "vpk") != nil {
                    //vm.fetchWeekVPK(isOtherWeek: true, vpk: UserDefaults.standard.string(forKey: "vpk"))
                }
                weekSlider.insert(firstDate.createPrevioustWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: -1, to: vm.selectedDay) ?? timeManager.currentTime
                vm.updateSelectedDayIndex()
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date,
                currentWeekIndex == (weekSlider.count - 1) {
                vm.week += 1
                if !groupsKeys.isEmpty {
                    vm.fetchWeekSchedule(isOtherWeek: true)
                }
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: 1, to: vm.selectedDay) ?? timeManager.currentTime
                vm.updateSelectedDayIndex()
            }
        }
    }
}

extension WeekViewForMonth {
    func getForegroundColor(day: Date.WeekDay) -> Color {
        if isDateInCurrentMonth(day.date) {
            return isSameDate(day.date, vm.selectedDay) ? .white : .black
        } else {
            return isSameDate(day.date, vm.selectedDay) ? .white : Color("greyForDaysInMonthTabView")
        }
    }
    
    func getBackgroundColor(day: Date.WeekDay) -> Color {
        return isSameDate(day.date, vm.selectedDay) ? Color("blueColor") : Color("background")
    }
    
    func overlay(day: Date.WeekDay) -> some View {
        Group {
            if day.date.isToday && !isSameDate(day.date, vm.selectedDay) {
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color("blueColor"), lineWidth: 2)
            }
        }
    }
    
    func handleTap(day: Date.WeekDay) {
        if isSameWeek(day.date, vm.selectedDay) {
            print("На одной неделе")
        }
        else {
            let groupsKeys = Array(vm.nameToHtml.keys)
            var difBetweenWeeks = weeksBetween(startDate: vm.selectedDay, endDate: day.date)
            if day.date < vm.selectedDay {
                difBetweenWeeks = difBetweenWeeks * -1
            }
            print(difBetweenWeeks)
            vm.week += difBetweenWeeks
            if !groupsKeys.isEmpty {
                vm.fetchWeekSchedule(isOtherWeek: true)
            }
            if UserDefaults.standard.string(forKey: "vpk") != nil {
                //vm.fetchWeekVPK(isOtherWeek: true, vpk: UserDefaults.standard.string(forKey: "vpk"))
            }
        }
        vm.selectedDay = day.date
        vm.updateSelectedDayIndex()
    }
}

extension MonthTabView {
    func updateMonthScreenViewForNewGroup() {
        let timeManager = TimeService.shared
        vm.updateSelectedDayIndex()
        if monthSlider.isEmpty {
            let currentMonth = timeManager.currentTime.fetchMonth(vm.selectedDay)
            
            if let firstDate = currentMonth.first?.week[0].date {
                let temp = firstDate.createPreviousMonth()
                print("First date - \(firstDate)")
                print(temp)
                monthSlider.append(temp)
            }
                
            monthSlider.append(currentMonth)
            
            if let lastDate = currentMonth.last?.week[6].date {
                let temp = lastDate.createNextMonth()
                monthSlider.append(temp)
            }
        }
    }
    
    func paginateMonth(_ indexOfWeek: Int = 0) {
        let timeManager = TimeService.shared
        let calendar = Calendar.current
        let groupsKeys = Array (vm.nameToHtml.keys)
        if monthSlider.indices.contains(currentMonthIndex) {
            if let firstDate = monthSlider[currentMonthIndex].first?.week[0].date,
                currentMonthIndex == 0 {
                monthSlider.insert(firstDate.createPreviousMonth(), at: 0)
                monthSlider.removeLast()
                currentMonthIndex = 1
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: -5, to: vm.selectedDay) ?? timeManager.currentTime
                vm.updateSelectedDayIndex()
                vm.week -= 5
                if !groupsKeys.isEmpty {
                    vm.fetchWeekSchedule(isOtherWeek: true)
                }
            }
            
            if let lastDate = monthSlider[currentMonthIndex].last?.week[6].date,
                currentMonthIndex == (monthSlider.count - 1) {
                monthSlider.append(lastDate.createNextMonth())
                monthSlider.removeFirst()
                currentMonthIndex = monthSlider.count - 2
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: 5, to: vm.selectedDay) ?? timeManager.currentTime
                vm.updateSelectedDayIndex()
                vm.week += 5
                if !groupsKeys.isEmpty {
                    vm.fetchWeekSchedule(isOtherWeek: true)
                }
            }
        }
    }
}
