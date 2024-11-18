//
//  NetworkError.swift
//  NewsApp
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation

enum NetworkError: String, Error {
    case invalidUrl = "Invalid URL"
    case invalidResponse = "Invalid response form the server"
    case invalidData = "Data received from the server is invalid"
}
