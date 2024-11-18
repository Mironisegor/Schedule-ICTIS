//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Egor Mironov on 18.11.2024.
//

import Foundation

final class NetworkManager {
    
    //MARK: Properties
    static let shared = NetworkManager()
    private let decoder = JSONDecoder()
    private let urlString = "https://webictis.sfedu.ru/schedule-api/?query=%D0%BA%D1%82%D0%B1%D0%BE2-6"
    
    //MARK: Initializer
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    //MARK: Methods
    func getSchedule() async throws -> Schedule {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidUrl}
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {throw NetworkError.invalidResponse}
        
        do {
            return try decoder.decode(Schedule.self, from: data)
        }
        catch {
            throw NetworkError.invalidData
        }
    }
}
