//
//  WeekTabView.swift
//  Schedule ICTIS
//
//  Created by G412 on 10.12.2024.
//

import SwiftUI

struct WeekTabView: View {
    @State private var currentWeekIndex: Int = 1
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var createWeek: Bool = false
    @ObservedObject var vm: ViewModel
    var body: some View {
        HStack {
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .onAppear(perform: {
            vm.updateSelectedDayIndex()
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
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack (spacing: 10) {
            ForEach(week) { day in
                VStack (spacing: 1) {
                    Text(day.date.format("E"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(day.date.format("E") == "Вс" ? Color(.red) : isSameDate(day.date, vm.selectedDay) ? Color("customGray1") : Color("customGray3"))
                        .padding(.top, 13)
                        .foregroundColor(.gray)
                    Text(day.date.format("dd"))
                        .font(.system(size: 15, weight: .bold))
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
    
    func paginateWeek() {
        let calendar = Calendar.current
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date,
               currentWeekIndex == 0 {
                switch (vm.numOfGroup) {
                case "":
                    vm.week -= 1
                default:
                    vm.fetchWeekSchedule("new week", -1)
                }
                weekSlider.insert(firstDate.createPrevioustWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: -1, to: vm.selectedDay) ?? Date.init()
                vm.updateSelectedDayIndex()
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date,
               currentWeekIndex == (weekSlider.count - 1) {
                switch (vm.numOfGroup) {
                case "":
                    vm.week += 1
                default:
                    vm.fetchWeekSchedule("new week", 1)
                }
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
                vm.selectedDay = calendar.date(byAdding: .weekOfYear, value: 1, to: vm.selectedDay) ?? Date.init()
                vm.updateSelectedDayIndex()
            }
        }
    }
}

#Preview {
    ContentView()
}
