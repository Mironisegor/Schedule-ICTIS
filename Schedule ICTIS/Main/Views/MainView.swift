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
    @State private var isShowingVPKLabel = false
    
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
                LoadingScheduleView()
            }
            else {
                ScheduleView(vm: vm, isScrolling: $isScrolling, isShowingVPKLabel: $isShowingVPKLabel)
            }
        }
        .alert(isPresented: $vm.isShowingAlertForIncorrectGroup, error: vm.errorInNetwork) { error in
            Button("ОК") {
                print("This alert")
                vm.isShowingAlertForIncorrectGroup = false
                vm.errorInNetwork = nil
            }
        } message: { error in
            Text(error.failureReason)
        }
        .background(Color("background"))
    }
    
    @ViewBuilder
    func CurrentDateView() -> some View {
        VStack (alignment: .leading, spacing: 6) {
            HStack {
                VStack (alignment: .leading, spacing: 0) {
                    Text(vm.selectedDay.format("EEEE"))
                        .font(.custom("Montserrat-SemiBold", fixedSize: 30))
                        .foregroundStyle(.black)
                    HStack (spacing: 5) {
                        Text(vm.selectedDay.format("dd"))
                            .font(.custom("Montserrat-Bold", fixedSize: 17))
                            .foregroundStyle(Color("grayForDate"))
                        Text(vm.selectedDay.format("MMMM"))
                            .font(.custom("Montserrat-Bold", fixedSize: 17))
                            .foregroundStyle(Color("grayForDate"))
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isShowingMonthSlider.toggle()
                            }
                        }) {
                            HStack(spacing: 2) {
                                Text(isShowingMonthSlider ? "Свернуть" : "Развернуть")
                                    .font(.custom("Montserrat-Regular", fixedSize: 15))
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
                WeekTabView(vm: vm, isShowingVPKLabel: $isShowingVPKLabel)
                    .transition(.opacity)
            }
            else {
                MonthTabView(vm: vm, isShowingVPKLabel: $isShowingVPKLabel)
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
