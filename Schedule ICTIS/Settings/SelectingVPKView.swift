//
//  SelectedGroupView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 30.01.2025.
//

import SwiftUI

struct SelectingVPKView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @ObservedObject var vm: ScheduleViewModel
    @State private var isLoading = false
    @State private var searchTask: DispatchWorkItem?
    @StateObject private var serchGroupsVM = SearchGroupsViewModel()
    var firstFavVPK: String
    var secondFavVPK: String
    var thirdFavVPK: String
    var body: some View {
        VStack {
            HStack (spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                    .padding(.leading, 12)
                    .padding(.trailing, 7)
                TextField("Поиск ВПК", text: $text)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .onChange(of: text) { oldValue, newValue in
                        searchTask?.cancel()
                        let task = DispatchWorkItem {
                            if !text.isEmpty {
                                serchGroupsVM.fetchGroups(group: text)
                            }
                            else {
                                serchGroupsVM.fetchGroups(group: "ВПК")
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
                                    if firstFavVPK == "" {
                                        UserDefaults.standard.set(text, forKey: "vpk1")
                                    } else if secondFavVPK == "" {
                                        UserDefaults.standard.set(text, forKey: "vpk2")
                                    } else {
                                        UserDefaults.standard.set(text, forKey: "vpk3")
                                    }
                                    vm.nameToHtml[text] = ""
                                    vm.fetchWeekSchedule()
                                    self.isLoading = false
                                    self.text = ""
                                    print("✅ - Избранный ВПК был установлен")
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
                ListOfGroupsView(vm: vm, serchGroupsVM: serchGroupsVM, firstFavVPK: firstFavVPK, secondFavVPK: secondFavVPK, thirdFavVPK: thirdFavVPK)
            }
        }
        .padding(.horizontal, 10)
        .background(Color("background"))
        .onAppear {
            serchGroupsVM.fetchGroups(group: "ВПК")
        }
    }
}
 
#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    SelectingVPKView(vm: vm, firstFavVPK: "", secondFavVPK: "", thirdFavVPK: "")
}
