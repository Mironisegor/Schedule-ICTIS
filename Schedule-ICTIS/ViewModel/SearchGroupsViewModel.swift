//
//  SearchGroupsViewModel.swift
//  Schedule ICTIS
//
//  Created by G412 on 06.03.2025.
//

import Foundation

@MainActor
final class SearchGroupsViewModel: ObservableObject {
    @Published var groups: [Subject] = []
    
    func fetchGroups(group: String) {
        Task {
            do {
                var groups: Welcome
                groups = try await NetworkManager.shared.getGroups(group: group)
                self.groups = groups.choices
                if (group == "кт") {
                    self.sortGroups()
                } else {
                    self.sortVPK()
                }
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
    
    // Метод сортировки
    func sortGroups() {
        groups.sort { (group1, group2) in
            // Извлекаем компоненты из названия групп
            let components1 = extractComponents(from: group1.name)
            let components2 = extractComponents(from: group2.name)
            
            // Сравниваем сначала по номеру курса (первая цифра после букв)
            if components1.courseNumber != components2.courseNumber {
                return components1.courseNumber < components2.courseNumber
            }
            
            // Если номера курсов равны, сравниваем по номеру группы (число после дефиса)
            return components1.groupNumber < components2.groupNumber
        }
    }
        
    // Вспомогательная структура для хранения извлеченных компонентов
    private struct GroupComponents {
        let courseNumber: Int
        let groupNumber: Int
    }
        
    // Метод для извлечения числовых компонентов из названия группы
    private func extractComponents(from name: String) -> GroupComponents {
        // Находим индекс дефиса
        guard let hyphenIndex = name.firstIndex(of: "-") else {
            return GroupComponents(courseNumber: 0, groupNumber: 0)
        }
        
        // Извлекаем часть до дефиса (буквы и номер курса)
        let prefix = String(name[..<hyphenIndex])
        // Извлекаем часть после дефиса (номер группы)
        let suffix = String(name[name.index(after: hyphenIndex)...])
        
        // Извлекаем цифры из prefix
        let courseNumberString = prefix.trimmingCharacters(in: CharacterSet.letters)
        let courseNumber = Int(courseNumberString) ?? 0
        
        // Преобразуем suffix в число
        let groupNumber = Int(suffix) ?? 0
        
        return GroupComponents(courseNumber: courseNumber, groupNumber: groupNumber)
    }
    
    // Метод сортировки для ВПК групп
    func sortVPK() {
        groups.sort { (group1, group2) in
            let components1 = extractVPKComponents(from: group1.name)
            let components2 = extractVPKComponents(from: group2.name)
            
            // Сравниваем по типу (мВПК после ВПК)
            if components1.isMinor != components2.isMinor {
                return !components1.isMinor // ВПК идет перед мВПК
            }
            
            // Сравниваем по первому номеру
            if components1.firstNumber != components2.firstNumber {
                return components1.firstNumber < components2.firstNumber
            }
            
            // Если первые номера равны, сравниваем по второму номеру (если есть)
            // Используем nil coalescing для случаев, когда второго номера нет
            return (components1.secondNumber ?? Int.max) < (components2.secondNumber ?? Int.max)
        }
    }
        
    // Вспомогательная структура для хранения компонентов ВПК
    private struct VPKComponents {
        let isMinor: Bool // true для мВПК, false для ВПК
        let firstNumber: Int
        let secondNumber: Int?
    }
    
    // Метод для извлечения компонентов из названия ВПК группы
    private func extractVPKComponents(from name: String) -> VPKComponents {
        let isMinor = name.hasPrefix("мВПК")
        
        // Убираем префикс и разбиваем по дефису
        let cleanName = isMinor ? name.replacingOccurrences(of: "мВПК-", with: "") : name.replacingOccurrences(of: "ВПК ", with: "")
        let components = cleanName.split(separator: "-")
        
        // Извлекаем первый номер
        let firstNumberString = String(components[0]).trimmingCharacters(in: .whitespaces)
        let firstNumber = Int(firstNumberString) ?? 0
        
        // Извлекаем второй номер, если он есть
        let secondNumber: Int?
        if components.count > 1 {
            secondNumber = Int(components[1]) ?? 0
        } else {
            secondNumber = nil
        }
        
        return VPKComponents(isMinor: isMinor, firstNumber: firstNumber, secondNumber: secondNumber)
    }
}
