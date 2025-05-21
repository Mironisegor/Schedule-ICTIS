//
//  JsonClassModel.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 27.03.2025.
//

import Foundation
import CoreData

final class JsonClassModel: NSManagedObject, Identifiable {
    @NSManaged var name: String
    @NSManaged var group: String
    @NSManaged var time: String
    @NSManaged var day: Int16
    @NSManaged var week: Int16
    
    // Здесь мы выполняем дополнительную инициализацию, назначая значения по умолчанию
    // Этот метод вызывается всякий раз, когда объект Core Data вставляется в контекст
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue("", forKey: "name")
        setPrimitiveValue("", forKey: "group")
        setPrimitiveValue("", forKey: "time")
        setPrimitiveValue(0, forKey: "day")
        setPrimitiveValue(0, forKey: "week")
    }
}

// Расширение для загрузки данных из памяти
extension JsonClassModel {
    // Получаем все данные из памяти
    private static var subjectsFetchRequest: NSFetchRequest<JsonClassModel> {
        NSFetchRequest(entityName: "JsonClassModel")
    }
    
    // Получаем все данные и сортируем их по дню
    // Этот метод будет использоваться на View(ScheduleView), где отображаются пары
    static func all() -> NSFetchRequest<JsonClassModel> {
        let request: NSFetchRequest<JsonClassModel> = subjectsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \JsonClassModel.time, ascending: true)
        ]
        return request
    }
    
    static func deleteClasses(withName name: String, in context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<JsonClassModel> = JsonClassModel.all()
        fetchRequest.predicate = NSPredicate(format: "group == %@", name)
        
        let groupsToDelete = try context.fetch(fetchRequest)
        
        for group in groupsToDelete {
            do {
                try ClassProvider.shared.delete(group, in: context)
            }
            catch {
                print(error)
            }
        }
    }
}
