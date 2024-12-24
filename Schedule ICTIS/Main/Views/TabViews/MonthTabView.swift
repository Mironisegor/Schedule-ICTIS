//
//  MonthTabView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 10.12.2024.
//

import SwiftUI

struct MonthTabView: View {
    @State private var currentMonthIndex: Int = 1
    @State private var monthSlider: [[Date.MonthWeek]] = []
    @State private var createMonth: Bool = false
    @State private var currentWeekIndex: Int = 0
    @ObservedObject var vm: ScheduleViewModel
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
        }
        .onAppear(perform: {
            vm.updateSelectedDayIndex()
            if monthSlider.isEmpty {
                let currentMonth = Date().fetchMonth(vm.selectedDay)
                
                if let firstDate = currentMonth.first?.week[0].date {
                    monthSlider.append(firstDate.createPreviousMonth())
                }
                    
                monthSlider.append(currentMonth)
                
                if let lastDate = currentMonth.last?.week[6].date {
                    monthSlider.append(lastDate.createNextMonth())
                }
            }
        })
        .onChange(of: currentMonthIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (monthSlider.count - 1) {
                createMonth = true
            }
        }
    }
    
    @ViewBuilder
    func MonthView(_ month: [Date.MonthWeek]) -> some View {
        VStack (spacing: 10) {
            ForEach(month.indices, id: \.self) { index in
                let week = month[index].week
                WeekViewForMonth(week: week, vm: vm)
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if (abs(value.rounded()) - 20) < 5 && createMonth {
                            paginateMonth()
                            
                            createMonth = false
                        }
                    }
            }
        }
    }
    
    func paginateMonth(_ indexOfWeek: Int = 0) {
        let calendar = Calendar.current
        if monthSlider.indices.contains(currentMonthIndex) {
            if let firstDate = monthSlider[currentMonthIndex].first?.week[0].date,
               currentMonthIndex == 0 {
                monthSlider.insert(firstDate.createPreviousMonth(), at: 0)
                monthSlider.removeLast()
                currentMonthIndex = 1
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: -5, to: vm.selectedDay) ?? Date.init()
                vm.updateSelectedDayIndex()
                vm.week -= 5
                vm.fetchWeekSchedule("")
            }
            
            if let lastDate = monthSlider[currentMonthIndex].last?.week[6].date,
               currentMonthIndex == (monthSlider.count - 1) {
                monthSlider.append(lastDate.createNextMonth())
                monthSlider.removeFirst()
                currentMonthIndex = monthSlider.count - 2
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: 5, to: vm.selectedDay) ?? Date.init()
                vm.updateSelectedDayIndex()
                vm.week += 5
                vm.fetchWeekSchedule("")
            }
        }
    }
}

#Preview {
    ContentView()
}
