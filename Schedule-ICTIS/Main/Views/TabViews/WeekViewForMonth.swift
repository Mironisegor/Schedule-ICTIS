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
                        .font(.custom("Montserrat-SemiBold", fixedSize: 15))
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
}
