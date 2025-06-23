//
//  DateModel.swift
//  Schedule-ICTIS
//
//  Created by G412 on 23.06.2025.
//

import Foundation

// MARK: - DateModel
struct DateModel: Decodable {
    let timezone, formatted: String
    let timestamp, weekDay, day, month: Int
    let year, hour, minute: Int
}
