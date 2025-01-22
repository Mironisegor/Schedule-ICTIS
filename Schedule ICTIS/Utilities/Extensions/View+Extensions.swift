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

extension CreateEditClassView {
    func delete(_ _class: ClassModel) throws {
        let context = provider.viewContext
        let existingClass = try context.existingObject(with: _class.objectID)
        context.delete(existingClass)
        Task (priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
}
