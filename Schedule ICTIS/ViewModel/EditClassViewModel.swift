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
    
    private let context: NSManagedObjectContext
    
    init(provider: ClassProvider, _class: ClassModel? = nil) {
        self.context = provider.newContext
        self._class = ClassModel(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
