//
//  Field.swift
//  Schedule ICTIS
//
//  Created by G412 on 16.12.2024.
//

import SwiftUI

struct FieldView: View {
    @Binding var text: String
    var nameOfImage: String
    var labelForField: String
    @FocusState private var isFocused: Bool
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: nameOfImage)
                .foregroundColor(Color.gray)
                .padding(.leading, 12)
                .padding(.trailing, 7)
            TextField(labelForField, text: $text)
                .font(.system(size: 18, weight: .regular))
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
    ContentView()
}
