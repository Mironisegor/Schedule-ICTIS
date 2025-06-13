//
//  Date+Extensions.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 14.11.2024.
//

import SwiftUI


extension Date {
    func format(_ format: String, locale: Locale = Locale(identifier: "ru_RU")) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = locale
            let formattedString = formatter.string(from: self)
            
            if format == "EEEE" {
                return formattedString.prefix(1).capitalized + formattedString.dropFirst()
            }
            
            return formattedString
        }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    func fetchWeek(_ date: Date = TimeService.shared.currentTime) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        // Создаем дату начала и конца недели
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        //print("Start: \(weekForDate?.start)")
        //print("End: \(weekForDate?.end)")
        
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        // Создаем массив дней для недели
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(WeekDay(date: weekDay))
            }
        }
        
        return week
    }
    
    func fetchMonth(_ date: Date = TimeService.shared.currentTime) -> [MonthWeek] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        var month: [MonthWeek] = []
        
        for weekIndex in 0..<5 {
            var week: [WeekDay] = []
            for dayIndex in 0..<7 {
                if let weekDay = calendar.date(byAdding: .day, value: (weekIndex * 7 + dayIndex), to: startOfWeek) {
                    week.append(WeekDay(date: weekDay))
                }
            }
            month.append(MonthWeek(week: week))
        }
        
        return month
    }
    
    func createNextMonth() -> [MonthWeek] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        return fetchMonth(nextDate)
    }
    
    func createPreviousMonth() -> [MonthWeek] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .weekOfMonth, value: -5, to: startOfFirstDate) else {
            return []
        }
        print("Start of first date \(startOfFirstDate)")
        print("Previous date \(previousDate)")
        return fetchMonth(previousDate)
    }
    
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        return fetchWeek(nextDate)
    }
    
    func createPrevioustWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        return fetchWeek(previousDate)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
    
    struct MonthWeek: Identifiable {
        var id: UUID = .init()
        var week: [WeekDay]
    }
}
