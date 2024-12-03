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
}
