//
//  Date+Extensions.swift
//  Schedule ICTIS
//
//  Created by G412 on 14.11.2024.
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
    
    private func isSameDate(_ date1: Date?, _ date2: Date?) -> Bool {
            guard let date1 = date1, let date2 = date2 else { return false }
            let calendar = Calendar.current
            return calendar.isDate(date1, inSameDayAs: date2)
        }
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
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
}
