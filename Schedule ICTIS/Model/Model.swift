//
//  ViewModel.swift
//  Schedule ICTIS
//
//  Created by G412 on 13.11.2024.
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
