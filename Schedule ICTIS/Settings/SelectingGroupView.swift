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
    @StateObject private var serchGroupsVM = SearchGroupsViewModel()
    var firstFavGroup: String
    var secondFavGroup: String
    var thirdFavGroup: String
    var body: some View {
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
                                serchGroupsVM.fetchGroups(group: text)
                            }
                            else {
                                serchGroupsVM.fetchGroups(group: "кт")
                            }
                        }
                        searchTask = task
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
                    }
                    .onSubmit {
                        self.isFocused = false
                        if (!text.isEmpty) {
                            vm.fetchWeekSchedule(isOtherWeek: false)
                            self.isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if vm.errorInNetwork == .noError {
                                    vm.errorInNetwork = nil
                                    if firstFavGroup == "" {
                                        UserDefaults.standard.set(text, forKey: "group")
                                        vm.nameToHtml[text] = ""
                                    } else if secondFavGroup == "" {
                                        UserDefaults.standard.set(text, forKey: "group2")
                                        vm.nameToHtml[text] = ""
                                    } else {
                                        UserDefaults.standard.set(text, forKey: "group3")
                                        vm.nameToHtml[text] = ""
                                    }
                                    vm.fetchWeekSchedule()
                                    self.isLoading = false
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
            //if isFocused {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(serchGroupsVM.groups) { item in
                        if item.name.starts(with: "КТ") { //Отображаем только группы(без аудиторий и преподавателей)
                            VStack {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("customGray1"))
                                    .padding(.horizontal, 10)
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.black)
                                        .font(.custom("Montserrat-SemiBold", fixedSize: 15))
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                .padding(.top, 2)
                                .padding(.bottom, 2)
                                .frame(width: UIScreen.main.bounds.width, height: 30)
                                .background(Color("background"))
                                .onTapGesture {
                                    if firstFavGroup == "" {
                                        UserDefaults.standard.set(item.name, forKey: "group")
                                        vm.nameToHtml[item.name] = ""
                                    } else if secondFavGroup == "" {
                                        UserDefaults.standard.set(item.name, forKey: "group2")
                                        vm.nameToHtml[item.name] = ""
                                    } else {
                                        UserDefaults.standard.set(item.name, forKey: "group3")
                                        vm.nameToHtml[item.name] = ""
                                    }
                                    vm.fetchWeekSchedule()
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            //}
        }
        .padding(.horizontal, 10)
        .background(Color("background"))
        .onAppear {
            serchGroupsVM.fetchGroups(group: "кт")
        }
    }
}
 
#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    SelectingGroupView(vm: vm, firstFavGroup: "", secondFavGroup: "", thirdFavGroup: "")
}
