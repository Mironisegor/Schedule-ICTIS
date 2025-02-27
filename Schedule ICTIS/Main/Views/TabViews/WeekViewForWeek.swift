//
//  WeekView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 20.12.2024.
//

import SwiftUI

struct WeekViewForWeek: View {
    @Binding var weekSlider: [[Date.WeekDay]]
    @Binding var currentWeekIndex: Int
    @Binding var createWeek: Bool
    let week: [Date.WeekDay]
    @ObservedObject var vm: ScheduleViewModel
    var body: some View {
        HStack (spacing: 10) {
            ForEach(week) { day in
                VStack (spacing: 1) {
                    Text(day.date.format("E"))
                        .font(.custom("Montserrat-SemiBold", fixedSize: 15))
                        .foregroundColor(day.date.format("E") == "Вс" ? Color(.red) : isSameDate(day.date, vm.selectedDay) ? Color("customGray1") : Color("customGray3"))
                        .padding(.top, 13)
                        .foregroundColor(.gray)
                    Text(day.date.format("dd"))
                        .font(.custom("Montserrat-Semibold", fixedSize: 15))
                        .foregroundStyle(isSameDate(day.date, vm.selectedDay) ? .white : .black)
                        .padding(.bottom, 13)
                }
                .frame(width: 43, height: 55,  alignment: .center)
                .background( content: {
                    Group {
                        if isSameDate(day.date, vm.selectedDay) {
                            Color("blueColor")
                        }
                        else {
                            Color(.white)
                        }
                        if isSameDate(day.date, vm.selectedDay) {
                            Color("blueColor")
                        }
                    }
                }
                )
                .overlay (
                    Group {
                        if day.date.isToday && !isSameDate(day.date, vm.selectedDay) {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("blueColor"), lineWidth: 2)
                        }
                    }
                )
                .cornerRadius(15)
                .onTapGesture {
                    vm.selectedDay = day.date
                    vm.updateSelectedDayIndex()
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                    
                        createWeek = false
                    }
                }
            }
        }
    }
}
