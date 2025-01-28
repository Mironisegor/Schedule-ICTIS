//
//  Field.swift
//  Schedule ICTIS
//
//  Created by G412 on 16.12.2024.
//

import SwiftUI

struct SubjectFieldView: View {
    @Binding var text: String
    @Binding var isShowingSubjectFieldRed: Bool
    @Binding var labelForField: String
    @FocusState var isFocused: Bool
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "book")
                .foregroundColor(Color.gray)
                .padding(.leading, 12)
                .padding(.trailing, 7)
            TextField(labelForField, text: $text)
                .font(.system(size: 18, weight: .regular))
                .disableAutocorrection(true)
                .submitLabel(.done)
                .focused($isFocused)
                .onChange(of: isFocused, initial: false) { oldValue, newValue in
                    if newValue {
                        self.isShowingSubjectFieldRed = false
                        self.labelForField = "Предмет"
                    }
                }
                .background {
                    Group {
                        if isShowingSubjectFieldRed {
                            Text("Поле должно быть заполнено!")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.red)
                                .frame(width: 290)
                                .padding(.leading, -42)
                        }
                    }
                }
            if isFocused {
                Button {
                    self.text = ""
                    self.isFocused = false
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

#Preview {
    SubjectFieldView(text: .constant(""), isShowingSubjectFieldRed: .constant(false), labelForField: .constant("Предмет"))
}
