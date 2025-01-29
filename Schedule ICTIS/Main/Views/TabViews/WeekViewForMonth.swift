//
//  WeekViewForMonth.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 20.12.2024.
//

import SwiftUI

struct WeekViewForMonth: View {
    let week: [Date.WeekDay]
    @ObservedObject var vm: ScheduleViewModel
    
    var body: some View {
        HStack(spacing: 23) {
            ForEach(week) { day in
                VStack {
                    Text(day.date.format("dd"))
                        .font(.custom("Montserrat-Medium", size: 15))
                        .foregroundStyle(getForegroundColor(day: day))
                }
                .frame(width: 30, height: 30, alignment: .center)
                .background(getBackgroundColor(day: day))
                .overlay(overlay(day: day))
                .cornerRadius(15)
                .onTapGesture {
                    handleTap(day: day)
                }
            }
        }
    }
    
    private func getForegroundColor(day: Date.WeekDay) -> Color {
        if isDateInCurrentMonth(day.date) {
            return isSameDate(day.date, vm.selectedDay) ? .white : .black
        } else {
            return isSameDate(day.date, vm.selectedDay) ? .white : Color("greyForDaysInMonthTabView")
        }
    }
    
    private func getBackgroundColor(day: Date.WeekDay) -> Color {
        return isSameDate(day.date, vm.selectedDay) ? Color("blueColor") : Color("background")
    }
    
    private func overlay(day: Date.WeekDay) -> some View {
        Group {
            if day.date.isToday && !isSameDate(day.date, vm.selectedDay) {
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color("blueColor"), lineWidth: 2)
            }
        }
    }
    
    private func handleTap(day: Date.WeekDay) {
        if isSameWeek(day.date, vm.selectedDay) {
            print("На одной неделе")
        }
        else {
            var difBetweenWeeks = weeksBetween(startDate: vm.selectedDay, endDate: day.date)
            if day.date < vm.selectedDay {
                difBetweenWeeks = difBetweenWeeks * -1
            }
            print(difBetweenWeeks)
            vm.week += difBetweenWeeks
            vm.fetchWeekSchedule(isOtherWeek: true)
            }
        vm.selectedDay = day.date
        vm.updateSelectedDayIndex()
    }
}
