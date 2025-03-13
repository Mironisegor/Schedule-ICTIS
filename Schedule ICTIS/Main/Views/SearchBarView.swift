//
//  SearchBarView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    @State private var isShowingSheet: Bool = false
    @ObservedObject var vm: ScheduleViewModel
    @Binding var isShowingMonthSlider: Bool

    var provider = ClassProvider.shared

    var body: some View {
        HStack (spacing: 11) {
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
                            vm.searchingGroup = text
                            vm.updateArrayOfGroups()
                            vm.fetchWeekSchedule()
                        }
                        self.text = ""
                    }
                    .submitLabel(.search)
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
            .simultaneousGesture(TapGesture().onEnded {
                self.isShowingMonthSlider = false
            })
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            if !isFocused {
                Button {
                    isShowingSheet = true
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color("blueColor"))
                            .cornerRadius(15)
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(.white)
                            .scaledToFit()
                            .frame(width: 16)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 5)
        .frame(height: 40)
        .accentColor(.blue)
        .sheet(isPresented: $isShowingSheet) {
            CreateEditClassView(vm: .init(provider: provider), day: vm.selectedDay)
        }
    }
}

#Preview {
    ContentView()
}
