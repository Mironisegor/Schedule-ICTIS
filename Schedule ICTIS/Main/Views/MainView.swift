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
    @State private var isFirstAppearence = true
    @ObservedObject var vm: ScheduleViewModel
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText, vm: vm)
            
            if (vm.isFirstStartOffApp && vm.isLoading) {
                LoadingView(isLoading: $vm.isLoading)
            }
            else if (vm.isFirstStartOffApp) {
                FirstLaunchScheduleView()
            }
            else {
                CurrentDateView()
                ScheduleView(vm: vm)
            }
        }
        .alert(isPresented: $vm.isShowingAlertForIncorrectGroup, error: vm.errorInNetwork) { error in
            
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
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(.black)
                    HStack (spacing: 5) {
                        Text(vm.selectedDay.format("dd"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color("grayForDate"))
                        Text(vm.selectedDay.format("MMMM"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color("grayForDate"))
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isShowingMonthSlider.toggle()
                            }
                        }) {
                            HStack(spacing: 2) {
                                Text(isShowingMonthSlider ? "Свернуть" : "Развернуть")
                                    .font(.system(size: 16, weight: .light))
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
