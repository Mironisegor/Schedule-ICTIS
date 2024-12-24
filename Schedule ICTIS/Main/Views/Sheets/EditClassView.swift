//
//  SheetCreateClassView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 12.12.2024.
//

import SwiftUI

struct EditClassView: View {
    @State private var isIncorrectDate1: Bool = false
    @State private var isIncorrectDate2: Bool = false
    @Binding var isShowingSheet: Bool
    
    let _class: ClassModel
    
    @State private var subject: String = ""
    
    var body: some View {
        NavigationStack {
            ProfessorAuditoryClassFieldView(text: $subject, nameOfImage: "book", labelForField: "Предмет")
                .padding(.bottom, 10)
            List {
                Section("General") {
                    LabeledContent {
                        Text(_class.subject)
                    } label: {
                        Text("Предмет")
                    }
                            
                    LabeledContent {
                        Text(_class.auditory)
                    } label: {
                        Text("Аудитория")
                    }
                            
                    LabeledContent {
                        Text(_class.day, style: .date)
                    } label: {
                        Text("Преподаватель")
                    }
                        
                }
                    
                Section("Notes") {
                    Text(_class.comment)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        isShowingSheet = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        isShowingSheet = false
                    }
                }
            }
        }
        .onAppear {
            subject = _class.subject
        }
    }
    
    func checkStartTimeLessThenEndTime(_ startTime: Date, _ endTime: Date) -> Bool {
        let calendar = Calendar.current
        
        let firstComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let secondComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        guard let startHours = firstComponents.hour, let startMinutes = firstComponents.minute else {
            return false
        }
        guard let endHours = secondComponents.hour, let endMinutes = secondComponents.minute else {
            return false
        }
        
        print("\(startHours) - \(endHours)")
        print("\(startMinutes) - \(endMinutes)")
        if Int(startHours) > Int(endHours) {
            return false
        }
        else if startHours == endHours {
            if startMinutes < endMinutes {
                return true
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }
}

#Preview {
    NavigationStack {
        EditClassView(isShowingSheet: .constant(true), _class: .preview())
    }
}
