//
//  NetworkError.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation

enum NetworkError: String, Error, LocalizedError {
    case invalidUrl
    case invalidResponse
    case invalidData
    case noError
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            "InvalidUrl"
        case .invalidResponse:
            "InvalidResponse"
        case .invalidData:
            "Проверьте номер группы"
        case .timeout:
            "Ошибка сети"
        case .noError:
            "Нет ошибки"
        }
    }
    
    var failureReason: String {
        switch self {
        case .invalidUrl:
            "Похоже не удалось составить ссылку для api"
        case .invalidResponse:
            "Для этой недели расписания еще нет"
        case .invalidData:
            "Похоже такой группы не существует"
        case .timeout:
            "Проверьте соединение с интернетом"
        case .noError:
            "Ошибки нет"
        }
    }
}
