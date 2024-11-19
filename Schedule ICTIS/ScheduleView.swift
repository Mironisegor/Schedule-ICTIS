//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by G412 on 13.11.2024.
//

import SwiftUI

struct ScheduleView: View {
    @State private var searchText: String = ""
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @StateObject var vm = ViewModel()

    var body: some View {
        VStack {
            SearchBarView(text: $searchText)
            HeaderView()
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(vm.weekSchedule, id: \.week) { element in
                        let selectedDayIndex = vm.selectedIndex
                        if selectedDayIndex < 8 {
                            let schedule = element.table[selectedDayIndex]
                            ForEach(schedule.indices.dropFirst(), id: \.self) { index in
                                let lesson = schedule[index]
                                let firstThreeCharacters = lesson.prefix(3)
                                let checkEnglish = lesson.prefix(6)
                                if !lesson.isEmpty && index != 0 {
                                    GeometryReader { geometry in
                                        HStack (spacing: 8) {
                                            VStack (alignment: .center) {
                                                Text(convertTimeString(element.table[1][index])[0])
                                                    .font(.system(size: 15, weight: .light))
                                                Text(convertTimeString(element.table[1][index])[1])
                                                    .font(.system(size: 15, weight: .light))
                                            }
                                            .padding(.top, 4)
                                            .padding(.bottom, 4)
                                            .padding(.leading, 8)
                                            Rectangle()
                                                .frame(maxHeight: geometry.size.height - 10)
                                                .frame(width: 3)
                                                .cornerRadius(20)
                                                .padding(.top, 4)
                                                .padding(.bottom, 4)
                                                .foregroundColor(checkEnglish == "пр.Ино" || firstThreeCharacters == "лек" ? Color.blue : Color.green)
                                            Text(lesson)
                                                .font(.system(size: 16, weight: .medium))
                                                .padding(.trailing, 8)
                                                .frame(maxWidth: 280, alignment: .leading) // Выравнивание текста по левому краю
                                                .padding(.top, 4)
                                                .padding(.bottom, 4)
                                                .multilineTextAlignment(.leading)

                                        }
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .padding(.horizontal, 10)
                                        .frame(maxWidth: 420, maxHeight: 130)
                                    }
                                    .frame(height: 70)
                                }
                            }
                        } else {
                            Text("Сегодня нет пар")
                        }
                    }
                }
            }
        }
        .background(.secondary.opacity(0.1))
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPrevioustWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
            vm.updateSelectedDayIndex(currentDate)
        })
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
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
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
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
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
            vm.updateSelectedIndex(newValue)
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack (spacing: 10) {
            ForEach(week) { day in
                VStack (spacing: 1) {
                    Text(day.date.format("E"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(day.date.format("E") == "Вс" ? Color(.red) : isSameDate(day.date, currentDate) ? Color("customGray1") : Color("customGray3"))
                        .padding(.top, 13)
                        .foregroundColor(.gray)
                    Text(day.date.format("dd"))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .black)
                        .padding(.bottom, 13)
                }
                .frame(width: 43, height: 55,  alignment: .center)
                .background( content: {
                    Group {
                        if isSameDate(day.date, currentDate) {
                            Color("blueColor")
                        }
                        else {
                            Color(.white)
                        }
                        if day.date.isToday && isSameDate(day.date, currentDate) {
                            Color("blueColor")
                        }
                    }
                }
                )
                .overlay (
                    Group {
                        if day.date.isToday && !isSameDate(day.date, currentDate) {
                            RoundedRectangle(cornerRadius: 15)
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
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date,
               currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPrevioustWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date,
               currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
    func convertTimeString(_ input: String) -> [String] {
        let parts = input.split(separator: "-")
        if let firstPart = parts.first, let lastPart = parts.last {
            return [String(firstPart), String(lastPart)]
        } else {
            return []
        }
    }
}

#Preview {
    ScheduleView()
}
