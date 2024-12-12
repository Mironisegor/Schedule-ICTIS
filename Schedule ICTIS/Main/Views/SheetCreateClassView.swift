//
//  SheetCreateClassView.swift
//  Schedule ICTIS
//
//  Created by G412 on 12.12.2024.
//

import SwiftUI

struct SheetCreateClassView: View {
    @Binding var isShowingSheet: Bool
    @State private var isEditingClass: Bool = false
    @State private var isEditingAuditory: Bool = false
    @State private var isEditingProfessor: Bool = false
    @State private var textForNameOfClass = ""
    @State private var textForNameOfAuditory = ""
    @State private var textForNameOfProfessor = ""
    

    var body: some View {
        NavigationView {
            VStack {
                FieldView(isEditing: $isEditingClass, text: $textForNameOfClass, nameOfImage: "book", labelForField: "Предмет")
                    .padding(.bottom, 10)
                FieldView(isEditing: $isEditingAuditory, text: $textForNameOfAuditory, nameOfImage: "mappin.and.ellipse", labelForField: "Корпус-аудитория")
                    .padding(.bottom, 10)
                FieldView(isEditing: $isEditingProfessor, text: $textForNameOfProfessor, nameOfImage: "book", labelForField: "Преподаватель")
                Spacer()
            }
            .padding()
            .background(Color("background"))
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
        .background(Color("background")) // Фон для всего sheet
    }
}

#Preview {
    SheetCreateClassView(isShowingSheet: .constant(true))
}

struct FieldView: View {
    @Binding var isEditing: Bool
    @Binding var text: String
    var nameOfImage: String
    var labelForField: String
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: nameOfImage)
                .foregroundColor(Color.gray)
                .padding(.leading, 12)
                .padding(.trailing, 7)
            TextField(labelForField, text: $text)
                .disableAutocorrection(true)
                .onTapGesture {
                    self.isEditing = true
                }
                .submitLabel(.search)
            if isEditing {
                Button {
                    self.text = ""
                    self.isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 20)
                        .offset(x: 10)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
    }
}
