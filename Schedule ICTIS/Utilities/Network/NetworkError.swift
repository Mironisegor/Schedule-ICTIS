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
    case noNetwork
    case noError
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            "InvalidUrl"
        case .invalidResponse:
            "InvalidResponse"
        case .invalidData:
            "Проверьте номер группы"
        case .noNetwork:
            "No network connection"
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
        case .noNetwork:
            "Проверьте подключение к интернету и попробуйте заново"
        case .noError:
            "Ошибки нет"
        }
    }
}
