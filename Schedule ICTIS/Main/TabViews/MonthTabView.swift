//
//  MonthTabView.swift
//  Schedule ICTIS
//
//  Created by G412 on 10.12.2024.
//

import SwiftUI

struct MonthTabView: View {
    @State private var currentMonthIndex: Int = 1
    @State private var monthSlider: [[Date.MonthWeek]] = []
    @State private var createMonth: Bool = false
    @State private var currentDate: Date = .init()
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            HStack (spacing: 34) {
                ForEach(MockData.daysOfWeek.indices, id: \.self) { index in
                    Text(MockData.daysOfWeek[index])
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(MockData.daysOfWeek[index] == "Вс" ? Color(.red) : Color("customGray2"))
                        .padding(.top, 13)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 14)
            //.background(Color.red)
            TabView(selection: $currentMonthIndex) {
                ForEach(monthSlider.indices, id: \.self) { index in
                    let month = monthSlider[index]
                    MonthView(month)
                        .tag(index)
                }
            }
            .padding(.top, -25)
            .padding(.bottom, -10)
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            //.background(Color.green)
        }
        .onChange(of: currentMonthIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (monthSlider.count - 1) {
                createMonth = true
            }
        }
        .onAppear(perform: {
            currentDate = vm.selectedDay
            vm.updateSelectedDayIndex(currentDate)
            if monthSlider.isEmpty {
                let currentMonth = Date().fetchMonth(vm.selectedDay)
                    
                monthSlider.append(currentMonth)
            }
        })
    }
    
    @ViewBuilder
    func MonthView(_ month: [Date.MonthWeek]) -> some View {
        VStack {
            ForEach(month.indices, id: \.self) { index in
                let week = month[index].week
                WeekView(week)
            }
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack (spacing: 23) {
            ForEach(week) { day in
                VStack {
                    Text(day.date.format("dd"))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(isDateInCurrentMonth(day.date) ? isSameDate(day.date, currentDate) ? Color.white : Color.black: isSameDate(day.date, currentDate) ? Color.white : Color("greyForDaysInMonthTabView"))
                }
                .frame(width: 30, height: 30,  alignment: .center)
                .background( content: {
                    Group {
                        if isSameDate(day.date, currentDate) {
                            Color("blueColor")
                        }
                        else {
                            Color("background")
                        }
                        if isSameDate(day.date, currentDate) {
                            Color("blueColor")
                        }
                    }
                }
                )
                .overlay (
                    Group {
                        if day.date.isToday && !isSameDate(day.date, currentDate) {
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color("blueColor"), lineWidth: 2)
                        }
                    }
                )
                .cornerRadius(15)
                .onTapGesture {
                    currentDate = day.date
                    vm.updateSelectedDayIndex(currentDate)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
