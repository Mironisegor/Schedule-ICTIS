//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct MainView: View {
    @State private var searchText: String = ""
    @State private var isShowingMonthSlider: Bool = false
    @ObservedObject var vm: ScheduleViewModel
    @FocusState private var isFocusedSearchBar: Bool
    @State private var isScrolling: Bool = false
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText, isFocused: _isFocusedSearchBar, vm: vm)
                .onChange(of: isScrolling, initial: false) { oldValue, newValue in
                    if newValue && isScrolling {
                        isFocusedSearchBar = false
                    }
                }
            CurrentDateView()
            if vm.isLoading {
                LoadingView(isLoading: $vm.isLoading)
            }
            else {
                ScheduleView(vm: vm, isScrolling: $isScrolling)
            }
        }
        .alert(isPresented: $vm.isShowingAlertForIncorrectGroup, error: vm.errorInNetwork) { error in
            
        } message: { error in
            Text(error.failureReason)
        }
        .background(Color("background"))
        .onTapGesture {
            isFocusedSearchBar = false
        }
        .onAppear {
            vm.group = UserDefaults.standard.string(forKey: "group") ?? "notSeted"
            if vm.group != "notSeted" {
                
            }
        }
    }
    
    @ViewBuilder
    func CurrentDateView() -> some View {
        VStack (alignment: .leading, spacing: 6) {
            HStack {
                VStack (alignment: .leading, spacing: 0) {
                    Text(vm.selectedDay.format("EEEE"))
                        .font(.custom("Montserrat-SemiBold", size: 40))
                        .foregroundStyle(.black)
                    HStack (spacing: 5) {
                        Text(vm.selectedDay.format("dd"))
                            .font(.custom("Montserrat-Bold", size: 20))
                            .foregroundStyle(Color("grayForDate"))
                        Text(vm.selectedDay.format("MMMM"))
                            .font(.custom("Montserrat-Bold", size: 20))
                            .foregroundStyle(Color("grayForDate"))
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isShowingMonthSlider.toggle()
                            }
                        }) {
                            HStack(spacing: 2) {
                                Text(isShowingMonthSlider ? "Свернуть" : "Развернуть")
                                    .font(.custom("Montserrat-Light", size: 16))
                                    .foregroundStyle(Color.blue)
                                Image(isShowingMonthSlider ? "arrowup" : "arrowdown")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 5)
                Spacer()
            }
            if (!isShowingMonthSlider) {
                WeekTabView(vm: vm)
                    .transition(.opacity)
            }
            else {
                MonthTabView(vm: vm)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.25), value: isShowingMonthSlider)
    }
}
#Preview {
    ContentView()
}
