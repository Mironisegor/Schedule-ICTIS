//
//  SaveScheduleViewModel.swift
//  Schedule ICTIS
//
//  Created by Egor Mironov on 02.04.2025.
//

import Foundation
import CoreData

final class SaveScheduleViewModel: ObservableObject {
    @Published var subject: JsonClassModel
    
    
    private let provider: ClassProvider
    
    private let context: NSManagedObjectContext
    
    init(provider: ClassProvider, subject: JsonClassModel? = nil) {
        self.provider = provider
        self.context = provider.newContext
        
        if let subject,
           let existingClassCopy = provider.exists(subject, in: context) {
            self.subject = existingClassCopy
        }
        else {
            self.subject = JsonClassModel(context: self.context)
        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
}
