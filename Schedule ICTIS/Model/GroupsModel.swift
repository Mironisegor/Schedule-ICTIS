//
//  SubjectsModel.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 19.02.2025.
//

import Foundation

// MARK: - Welcome
struct Welcome: Decodable {
    let choices: [Choice]
}

// MARK: - Choice
struct Choice: Decodable, Identifiable {
    let name: String
    let id: String
    let group: String
}
