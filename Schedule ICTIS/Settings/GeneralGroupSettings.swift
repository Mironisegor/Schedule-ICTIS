//
//  GeneralGroupSettings.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 25.02.2025.
//

import SwiftUI

struct GeneralGroupSettings: View {
    @Binding var selectedTheme: String
    @Binding var selectedLanguage: String
    var body: some View {
        VStack {
            HStack {
                Text("Тема")
                    .font(.custom("Montserrat-Medium", fixedSize: 17))
                    .foregroundColor(.black)
                Spacer()
                HStack {
                    Text(selectedTheme)
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(Color("customGray3"))
                    Image("upDownArrows")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top, 17)
            .padding(.bottom, 7)
            .overlay {
                HStack {
                    Spacer()
                    Picker("", selection: $selectedTheme, content: {
                        ForEach(MockData.themes, id: \.self) {
                            Text($0)
                        }
                    })
                    .padding(.trailing, 35)
                    .blendMode(.destinationOver)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            Rectangle()
                .foregroundColor(Color("customGray1"))
                .frame(height: 1)
                .padding(.horizontal)
            HStack {
                Text("Язык")
                    .font(.custom("Montserrat-Medium", fixedSize: 17))
                    .foregroundColor(.black)
                Spacer()
                HStack {
                    Text(selectedLanguage)
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(Color("customGray3"))
                    Image("upDownArrows")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top, 7)
            .padding(.bottom, 17)
            .overlay {
                HStack {
                    Spacer()
                    Picker("", selection: $selectedLanguage, content: {
                        ForEach(MockData.languages, id: \.self) {
                            Text($0)
                        }
                    })
                    .padding(.trailing, 35)
                    .blendMode(.destinationOver)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
        }
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    GeneralGroupSettings(selectedTheme: .constant("Темная"), selectedLanguage: .constant("Русский"))
}
