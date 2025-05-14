//
//  FavouriteGroupsModel.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 04.04.2025.
//

import Foundation
import CoreData

final class FavouriteVpkModel: NSManagedObject, Identifiable {
    @NSManaged var name: String
    
    // Здесь мы выполняем дополнительную инициализацию, назначая значения по умолчанию
    // Этот метод вызывается всякий раз, когда объект Core Data вставляется в контекст
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue("", forKey: "name")
    }
}

// Расширение для загрузки данных из памяти
extension FavouriteVpkModel {
    // Получаем все данные из памяти
    private static var favVpkFetchRequest: NSFetchRequest<FavouriteVpkModel> {
        NSFetchRequest(entityName: "FavouriteVpkModel")
    }
    
    // Получаем все данные и сортируем их по дню
    // Этот метод будет использоваться на View(ScheduleView), где отображаются пары
    static func all() -> NSFetchRequest<FavouriteVpkModel> {
        let request: NSFetchRequest<FavouriteVpkModel> = favVpkFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \FavouriteVpkModel.name, ascending: true)
        ]
        return request
    }
}
