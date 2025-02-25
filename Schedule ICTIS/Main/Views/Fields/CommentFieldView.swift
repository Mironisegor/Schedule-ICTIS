//
//  CommentView.swift
//  Schedule ICTIS
//
//  Created by G412 on 17.12.2024.
//

import SwiftUI

struct CommentFieldView: View {
    @Binding var textForComment: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("Комментарий", text: $textForComment)
                .font(.custom("Montserrat-Medium", fixedSize: 17))
                .submitLabel(.done)
                .multilineTextAlignment(.leading)
                .focused($isFocused)
                .padding(.top, 6)
                .padding(.bottom, 6)
            
            if isFocused {
                Button {
                    textForComment = ""
                    self.isFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 20)
                        .offset(x: 10)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(minHeight: 40)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
    }
}

