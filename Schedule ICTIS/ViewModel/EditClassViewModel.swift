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
    
    private let provider: ClassProvider
    
    private let context: NSManagedObjectContext
    
    init(provider: ClassProvider, _class: ClassModel? = nil) {
        self.provider = provider
        self.context = provider.newContext
        
        if let _class,
           let existingClassCopy = provider.exists(_class, in: context) {
            self._class = existingClassCopy
            self.isNew = false
        }
        else {
            self._class = ClassModel(context: self.context)
            self.isNew = true
        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
}
