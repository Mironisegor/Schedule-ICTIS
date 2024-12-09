//
//  NetworkManager.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.11.2024.
//

import Foundation

final class NetworkManager {
    //"https://webictis.sfedu.ru/schedule-api/?group=51.html&week=15"
    //MARK: Properties
    static let shared = NetworkManager()
    private let decoder = JSONDecoder()
    private let urlForGroup = "https://webictis.sfedu.ru/schedule-api/?query="
    private let urlForWeek = "https://webictis.sfedu.ru/schedule-api/?group="
    
    //MARK: Initializer
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    //MARK: Methods
    func makeUrlForGroup(_ group: String) -> String {
        return urlForGroup + group
    }
    
    func makeUrlForWeek(_ numOfWeek: Int, _ htmlNameOfGroup: String) -> String {
        return urlForWeek + htmlNameOfGroup + "&week=" + String(numOfWeek)
    }
    
    func getSchedule(_ group: String) async throws -> Schedule {
        let newUrlForGroup = makeUrlForGroup(group)
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
    
    func getScheduleForOtherWeek(_ numOfWeek: Int, _ htmlNameOfGroup: String) async throws -> Schedule {
        let newUrlForWeek = makeUrlForWeek(numOfWeek, htmlNameOfGroup)
        print(newUrlForWeek)
        guard let url = URL(string: newUrlForWeek) else {throw NetworkError.invalidUrl}
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
