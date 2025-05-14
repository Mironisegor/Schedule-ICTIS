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
        //Можно использовать объявление newContext с помощью строки, которая написана выше, но вариант ниже потокобезопаснее
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
        
        // Выставляем флаг для автоматического слияния данных из фонового контекста в основной
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        // Выполняем открытие файла с данными
        persistentContainer.loadPersistentStores {_, error in
            if let error {
                fatalError("Unable to load store. Error: \(error)")
            }
        }
    }
    
    func exists(_ lesson: CoreDataClassModel, in context: NSManagedObjectContext) -> CoreDataClassModel? {
        try? context.existingObject(with: lesson.objectID) as? CoreDataClassModel
    }
    
    func delete(_ lesson: CoreDataClassModel, in context: NSManagedObjectContext) throws {
        if let existingClass = exists(lesson, in: context) {
            context.delete(existingClass)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

extension ClassProvider {
    func exists(_ jsonClass: JsonClassModel, in context: NSManagedObjectContext) -> JsonClassModel? {
        try? context.existingObject(with: jsonClass.objectID) as? JsonClassModel
    }
    
    func delete(_ jsonClass: JsonClassModel, in context: NSManagedObjectContext) throws {
        if let existingJsonClass = exists(jsonClass, in: context) {
            context.delete(existingJsonClass)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    func exists(_ favGroup: FavouriteGroupModel, in context: NSManagedObjectContext) -> FavouriteGroupModel? {
        try? context.existingObject(with: favGroup.objectID) as? FavouriteGroupModel
    }
    
    func delete(_ favGroup: FavouriteGroupModel, in context: NSManagedObjectContext) throws {
        if let existingFavGroup = exists(favGroup, in: context) {
            context.delete(existingFavGroup)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    func exists(_ favVpk: FavouriteVpkModel, in context: NSManagedObjectContext) -> FavouriteVpkModel? {
        try? context.existingObject(with: favVpk.objectID) as? FavouriteVpkModel
    }
    
    func delete(_ favVpk: FavouriteVpkModel, in context: NSManagedObjectContext) throws {
        if let existingFavVpk = exists(favVpk, in: context) {
            context.delete(existingFavVpk)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
}

extension ClassProvider {
    
}
