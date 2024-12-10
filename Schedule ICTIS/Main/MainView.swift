//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct MainView: View {
    @State private var searchText: String = ""
    @State private var currentDate: Date = Date()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var isShowingMonthSlider: Bool = false
    @State private var isFirstAppearence = true
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText, vm: vm)
            if (vm.isFirstStartOffApp) {
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
        .onAppear(perform: {
            currentDate = vm.selectedDay
            vm.updateSelectedDayIndex(currentDate)
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek(vm.selectedDay)
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPrevioustWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
    }
    
    @ViewBuilder
    func CurrentDateView() -> some View {
        VStack (alignment: .leading, spacing: 6) {
            HStack {
                VStack (alignment: .leading, spacing: 0) {
                    Text(currentDate.format("EEEE"))
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(.black)
                    HStack (spacing: 5) {
                        Text(currentDate.format("dd"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color("grayForDate"))
                        Text(currentDate.format("MMMM"))
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
                                    .frame(width: 15, height: 15) // Установите размер изображения
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 5)
                Spacer()
            }
            if (!isShowingMonthSlider) {
                WeekTabView(currentWeekIndex: $currentWeekIndex, weekSlider: $weekSlider, currentDate: $currentDate, vm: vm)
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
