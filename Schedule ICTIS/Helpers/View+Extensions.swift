//
//  View+Extensions.swift
//  Schedule ICTIS
//
//  Created by G412 on 15.11.2024.
//

import SwiftUI

extension View {
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
