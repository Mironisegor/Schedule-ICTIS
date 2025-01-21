//
//  EditClassViewModel.swift
//  Schedule ICTIS
//
//  Created by G412 on 18.12.2024.
//

import Foundation
import CoreData

final class EditClassViewModel: ObservableObject {
    @Published var _class: ClassModel
    
    let isNew: Bool
    
    private let context: NSManagedObjectContext
    
    init(provider: ClassProvider, _class: ClassModel? = nil) {
        self.context = provider.newContext
        
        if let _class,
           let existingClassCopy = try? context.existingObject(with: _class.objectID) as? ClassModel {
            self._class = existingClassCopy
            self.isNew = false
        }
        else {
            self._class = ClassModel(context: self.context)
            self.isNew = true
        }
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
