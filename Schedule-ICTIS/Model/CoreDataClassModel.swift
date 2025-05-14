//
//  Class.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.12.2024.
//

import Foundation
import CoreData

final class CoreDataClassModel: NSManagedObject, Identifiable {
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
    
    static var dateNow: Date = .now
    
    // Здесь мы выполняем дополнительную инициализацию, назначая значения по умолчанию
    // Этот метод вызывается всякий раз, когда объект Core Data вставляется в контекст
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        let moscowTimeZone = TimeZone(identifier: "Europe/Moscow")!
        var calendar = Calendar.current
        calendar.timeZone = moscowTimeZone
        let startTime = Date()
        let endTime = calendar.date(byAdding: .hour, value: 1, to: Date.init())
        
        setPrimitiveValue("", forKey: "auditory")
        setPrimitiveValue("", forKey: "professor")
        setPrimitiveValue("", forKey: "subject")
        setPrimitiveValue("", forKey: "comment")
        setPrimitiveValue("Нет", forKey: "notification")
        setPrimitiveValue(false, forKey: "important")
        setPrimitiveValue("Оффлайн", forKey: "online")
        setPrimitiveValue(startTime, forKey: "day")
        setPrimitiveValue(startTime, forKey: "starttime")
        setPrimitiveValue(endTime, forKey: "endtime")
    }
}

// Расширение для загрузки данных из памяти
extension CoreDataClassModel {
    // Получаем все данные из памяти
    private static var classesFetchRequest: NSFetchRequest<CoreDataClassModel> {
        NSFetchRequest(entityName: "CoreDataClassModel")
    }
    
    // Получаем все данные и сортируем их по дню
    // Этот метод будет использоваться на View(ScheduleView), где отображаются пары
    static func all() -> NSFetchRequest<CoreDataClassModel> {
        let request: NSFetchRequest<CoreDataClassModel> = classesFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CoreDataClassModel.day, ascending: true)
        ]
        return request
    }
}

extension CoreDataClassModel {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [CoreDataClassModel] {
        var classes = [CoreDataClassModel]()
        for i in 0..<count {
            let _class = CoreDataClassModel(context: context)
            _class.subject = "Предмет \(i)"
            _class.auditory = "Аудитория \(i)"
            _class.professor = "Преподаватель \(i)"
            _class.day = Calendar.current.date(byAdding: .day, value: i, to: .now) ?? .now
            _class.starttime = Date()
            _class.endtime = Calendar.current.date(byAdding: .hour, value: i, to: .now) ?? .now
            classes.append(_class)
        }
        return classes
    }
    
    static func preview(context: NSManagedObjectContext = ClassProvider.shared.viewContext) -> CoreDataClassModel {
        return makePreview(count: 1, in: context)[0]
    }
        
    static func empty(context: NSManagedObjectContext = ClassProvider.shared.viewContext) -> CoreDataClassModel {
        return CoreDataClassModel(context: context)
    }
}
