//
//  Class.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.12.2024.
//

import Foundation
import CoreData

final class ClassModel: NSManagedObject, Identifiable {
    @NSManaged var auditory: String
    @NSManaged var professor: String
    @NSManaged var subject: String
    @NSManaged var comment: String
    @NSManaged var notification: String
    @NSManaged var day: Date
    @NSManaged var starttime: Date
    @NSManaged var endtime: Date
    @NSManaged var important: Bool
    @NSManaged var online: String
    
    // Здесь мы выполняем дополнительную инициализацию, назначая значения по умолчанию
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .hour, value: 1, to: Date.init())
        
        setPrimitiveValue("", forKey: "auditory")
        setPrimitiveValue("", forKey: "professor")
        setPrimitiveValue("", forKey: "subject")
        setPrimitiveValue("", forKey: "comment")
        setPrimitiveValue("Нет", forKey: "notification")
        setPrimitiveValue(false, forKey: "important")
        setPrimitiveValue("Оффлайн", forKey: "online")
        setPrimitiveValue(Date.init(), forKey: "day")
        setPrimitiveValue(Date.init(), forKey: "starttime")
        setPrimitiveValue(endTime, forKey: "endtime")
    }
}

// Расширение для загрузки данных из памяти
extension ClassModel {
    private static var classesFetchRequest: NSFetchRequest<ClassModel> {
        NSFetchRequest(entityName: "ClassModel")
    }
    
    // Получаем все данные из памяти
    static func all() -> NSFetchRequest<ClassModel> {
        let request: NSFetchRequest<ClassModel> = classesFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ClassModel.day, ascending: true)
        ]
        return request
    }
}
