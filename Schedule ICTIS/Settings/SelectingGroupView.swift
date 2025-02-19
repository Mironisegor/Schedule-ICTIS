//
//  SelectedGroupView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 30.01.2025.
//

import SwiftUI

struct SelectingGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @ObservedObject var vm: ScheduleViewModel
    @State private var isLoading = false
    @State private var searchTask: DispatchWorkItem?
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
                        .onChange(of: text) { oldValue, newValue in
                            searchTask?.cancel()
                            let task = DispatchWorkItem {
                                if !text.isEmpty {
                                    vm.fetchGroups(group: text)
                                }
                            }
                            searchTask = task
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
                        }
                        .onSubmit {
                            self.isFocused = false
                            if (!text.isEmpty) {
                                vm.fetchWeekSchedule(group: text)
                                self.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.isLoading = false
                                    if vm.errorInNetwork == .noError {
                                        vm.errorInNetwork = nil
                                        print("Зашел")
                                        UserDefaults.standard.set(text, forKey: "group")
                                        vm.group = text
                                        self.text = ""
                                        dismiss()
                                    }
                                    else {
                                        vm.isShowingAlertForIncorrectGroup = true
                                        vm.errorInNetwork = .invalidResponse
                                    }
                                }
                            }
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
                Spacer()
                if isLoading {
                    LoadingView(isLoading: $isLoading)
                }
                if isFocused {
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(vm.groups) { item in
                            VStack {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("customGray1"))
                                    .padding(.horizontal, 10)
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.black)
                                        .font(.custom("Montserrat-SemiBold", size: 15))
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                .padding(.top, 2)
                                .padding(.bottom, 2)
                                .frame(width: UIScreen.main.bounds.width, height: 30)
                                .background(Color("background"))
                                .onTapGesture {
                                    UserDefaults.standard.set(item.name, forKey: "group")
                                    vm.group = item.name
                                    vm.fetchWeekSchedule(group: item.name)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .background(Color("background"))
        }
        .onAppear {
            vm.fetchGroups(group: "кт")
        }
    }
}
