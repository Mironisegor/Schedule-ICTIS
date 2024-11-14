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
    @State private var currentWeekIndex: Int = 0
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
                weekSlider.append(currentWeek)
            }
        })

    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack (alignment: .leading, spacing: 6) {
            HStack (spacing: 5) {
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.blue)
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.blue)
            }
            .font(.title.bold())
//            Text(currentDate.formatted(date: .complete, time: .omitted))
//                .font(.title.bold())
            
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
        HStack (spacing: 14) {
            ForEach(week) { day in
                VStack (spacing: 4) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .padding(.top, 6)
                        .foregroundColor(.gray)
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .padding(.bottom, 6)
                }
                .frame(maxWidth: 40, maxHeight: 55,  alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ScheduleView()
}
