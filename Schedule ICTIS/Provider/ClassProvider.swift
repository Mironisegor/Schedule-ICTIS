//
//  ClassProvider.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.12.2024.
//

import Foundation
import CoreData
import SwiftUI

// Это класс служит посредником между View и моделью данных
// Он позволяет открыть наш файл данных чтобы записывать и извлекать значения
// Объект этого класса должен быть единственным за весь жизненный цикл приложения, чтобы не было рассинхронизации
// Для этого мы делаем его синглтоном
final class ClassProvider {
    static let shared = ClassProvider()
    
    // Это свойство для хранения открытого файла модели данных
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        //persistentContainer.newBackgroundContext()
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
                return context
    }
    
    private init() {
        // Открытие файла
        persistentContainer = NSPersistentContainer(name: "ClassDataModel")
        if EnvironmentValues.isPreview {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(filePath: "/dev/null")
        }
        
        // Выставляем флаг для автоматического сохранения изменений данных из Veiw в память
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        // Выполняем открытие файла с данными
        persistentContainer.loadPersistentStores {_, error in
            if let error {
                fatalError("Unable to load store. Error: \(error)")
            }
        }
        
    }
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
