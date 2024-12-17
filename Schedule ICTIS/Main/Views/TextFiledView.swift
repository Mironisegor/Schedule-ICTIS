//
//  TextFiledView.swift
//  Schedule ICTIS
//
//  Created by G412 on 17.12.2024.
//

import SwiftUI

struct TextFiledView: View {
    @State private var isEditing: Bool = false
    @State private var text: String = ""
    @State private var nameOfImage: String = "calendar"
    @State private var labelForField: String = "Преподаватель"
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: nameOfImage)
                .foregroundColor(Color.gray)
                .padding(.leading, 12)
                .padding(.trailing, 7)
            
            TextField(labelForField, text: $text)
                .font(.system(size: 18, weight: .regular))
                .disableAutocorrection(true)
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { newValue, oldValue in
                    isEditing = newValue
                }
                .submitLabel(.done)
            
            if isTextFieldFocused {
                Button {
                    self.text = ""
                    self.isEditing = false
                    isTextFieldFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .padding(.trailing, 20)
                        .offset(x: 10)
                        .foregroundColor(.red)
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
    TextFiledView()
}
