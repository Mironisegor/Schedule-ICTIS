//
//  AuditoryFieldView.swift
//  Schedule ICTIS
//
//  Created by G412 on 23.01.2025.
//

import SwiftUI

struct AuditoryFieldView: View {
    @Binding var text: String
    var labelForField: String
    @FocusState var isFocused: Bool
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(Color.gray)
                .padding(.leading, 12)
                .padding(.trailing, 14)
            TextField(labelForField, text: $text)
                .font(.custom("Montserrat-Meduim", fixedSize: 17))
                .disableAutocorrection(true)
                .submitLabel(.done)
                .focused($isFocused)
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
    AuditoryFieldView(text: .constant(""), labelForField: "Корпус-аудитория")
}
