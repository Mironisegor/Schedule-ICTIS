//
//  SelectedGroupView.swift
//  Schedule ICTIS
//
//  Created by G412 on 30.01.2025.
//

import SwiftUI

struct SelectingGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @Binding var group: String
    var body: some View {
        NavigationView {
            VStack {
                HStack (spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.gray)
                        .padding(.leading, 12)
                        .padding(.trailing, 7)
                    TextField("Поиск группы", text: $text)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                        .onSubmit {
                            self.isFocused = false
                            if (!text.isEmpty) {
                                UserDefaults.standard.set(text, forKey: "group")
                                group = text
                            }
                            self.text = ""
                            dismiss()
                        }
                        .submitLabel(.done)
                    if isFocused {
                        Button {
                            self.text = ""
                            self.isFocused = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.trailing, 20)
                                .offset(x: 10)
                                .foregroundColor(.gray)
                                .background(
                                )
                            }
                    }
                }
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                )
                .padding(.horizontal, 10)
                Spacer()
            }
            .background(Color("background"))
            .onTapGesture {
                self.isFocused = false
            }
        }
    }
}

#Preview {
    SelectingGroupView(group: .constant("КТбо2-6"))
}
