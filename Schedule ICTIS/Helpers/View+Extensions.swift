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
}
