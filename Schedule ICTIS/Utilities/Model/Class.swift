//
//  Class.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.12.2024.
//

import Foundation
import CoreData

final class Class: NSManagedObject {
    @NSManaged var auditory: String
    @NSManaged var professor: String
    @NSManaged var subject: String
    @NSManaged var comment: String
    @NSManaged var notification: String
    @NSManaged var day: Date
    @NSManaged var starttime: Date
    @NSManaged var endtime: Date
    @NSManaged var important: Bool
    
    // Здесь мы выполняем дополнительную инициализацию, назначая значения по умолчанию
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue("", forKey: "auditory")
        setPrimitiveValue("", forKey: "professor")
        setPrimitiveValue("", forKey: "subject")
        setPrimitiveValue("", forKey: "comment")
        setPrimitiveValue("Нет", forKey: "notification")
        setPrimitiveValue(false, forKey: "important")
    }
}
