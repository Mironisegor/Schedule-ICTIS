//
//  SearchGroupsViewModel.swift
//  Schedule ICTIS
//
//  Created by G412 on 06.03.2025.
//

import Foundation

@MainActor
final class SearchGroupsViewModel: ObservableObject {
    @Published var groups: [Choice] = []
    
    func fetchGroups(group: String) {
        Task {
            do {
                var groups: Welcome
                groups = try await NetworkManager.shared.getGroups(group: group)
                self.groups = groups.choices
                    
            }
            catch {
                if let error = error as? NetworkError {
                    switch (error) {
                    case .invalidData:
                        self.groups.removeAll()
                    default:
                        self.groups.removeAll()
                        print("Неизвестная ошибка: \(error)")
                    }
                    print("Есть ошибка: \(error)")
                }
            }
        }
    }
}
