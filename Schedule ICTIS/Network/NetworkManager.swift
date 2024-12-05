//
//  NetworkManager.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation

final class NetworkManager {
    
    //MARK: Properties
    static let shared = NetworkManager()
    private let decoder = JSONDecoder()
    private let urlForGroup = "https://webictis.sfedu.ru/schedule-api/?query="
    private let urlForWeek = "https://webictis.sfedu.ru/schedule-api/?group=51.html&week=15"
    private var groupString: String = ""
    private var numOfGroup: String = ""
    private var numOfWeek: String = ""
    
    //MARK: Initializer
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    //MARK: Methods
    func makeURL(_ group: String) -> String {
        return urlForGroup + group
    }
    
    func getSchedule(_ group: String) async throws -> Schedule {
        let newUrlForGroup = makeURL(group)
        guard let url = URL(string: newUrlForGroup) else {throw NetworkError.invalidUrl}
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
