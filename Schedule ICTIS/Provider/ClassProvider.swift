//
//  ClassProvider.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.12.2024.
//

import Foundation
import CoreData

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
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        // Открытие файла
        persistentContainer = NSPersistentContainer(name: "ClassDataModel")
        
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
