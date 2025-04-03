//
//  EditClassViewModel.swift
//  Schedule ICTIS
//
//  Created by Egor Mironov on 18.12.2024.
//

import Foundation
import CoreData

final class EditClassViewModel: ObservableObject {
    @Published var _class: CoreDataClassModel
    
    let isNew: Bool
    
    private let provider: ClassProvider
    
    private let context: NSManagedObjectContext
    
    init(provider: ClassProvider, _class: CoreDataClassModel? = nil) {
        self.provider = provider
        self.context = provider.newContext
        
        if let _class,
           let existingClassCopy = provider.exists(_class, in: context) {
            self._class = existingClassCopy
            self.isNew = false
        }
        else {
            self._class = CoreDataClassModel(context: self.context)
            self.isNew = true
        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
}
