//
//  Model.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import Foundation

// MARK: - Welcome
struct Schedule: Decodable {
    let table: Table
    let weeks: [Int]
}

// MARK: - Table
struct Table: Decodable {
    let type, name: String
    let week: Int
    let group: String
    let table: [[String]]
    let link: String
}

struct ClassInfo: Identifiable {
    let id = UUID()
    let subject: String
    let group: String
    let time: String
}
