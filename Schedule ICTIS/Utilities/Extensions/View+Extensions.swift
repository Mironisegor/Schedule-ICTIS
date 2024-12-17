//
//  View+Extensions.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 15.11.2024.
//

import SwiftUI

extension View {
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func isDateInCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        
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
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
