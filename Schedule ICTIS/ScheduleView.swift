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
    var body: some View {
        VStack {
            SearchBarView(text: $searchText)
            HeaderView()
            Spacer()
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
//                        .background(Color.green)
                    HStack (spacing: 5) {
                        Text(currentDate.format("dd"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color("grayForDate"))
                        Text(currentDate.format("MMMM"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color("grayForDate"))
                    }
//                    .background(.red)
                }
                .padding(.top, 8)
                .padding(.leading, 20)
//                .background(Color.brown)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
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
                }
            }
        }
    }
}

#Preview {
    ScheduleView()
}
