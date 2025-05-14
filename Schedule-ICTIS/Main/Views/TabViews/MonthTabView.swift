//
//  MonthTabView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 10.12.2024.
//

import SwiftUI

struct MonthTabView: View {
    @State var currentMonthIndex: Int = 1
    @State var monthSlider: [[Date.MonthWeek]] = []
    @State private var createMonth: Bool = false
    @State private var currentWeekIndex: Int = 0
    @ObservedObject var vm: ScheduleViewModel
    var body: some View {
        VStack {
            HStack (spacing: 33) {
                ForEach(MockData.daysOfWeek.indices, id: \.self) { index in
                    Text(MockData.daysOfWeek[index])
                        .font(.custom("Montserrat-SemiBold", fixedSize: 15))
                        .foregroundColor(MockData.daysOfWeek[index] == "Вс" ? Color(.red) : Color("customGray2"))
                }
            }
            TabView(selection: $currentMonthIndex) {
                ForEach(monthSlider.indices, id: \.self) { index in
                    let month = monthSlider[index]
                    MonthView(month)
                        .tag(index)
                        .transition(.slide)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            //.animation(.easeIn(duration: 0.3), value: currentMonthIndex)
        }
        .frame(height: 220)
        .padding(.top, 26)
        .padding(.bottom, 20)
        .onAppear {
            updateMonthScreenViewForNewGroup()
        }
        .onChange(of: currentMonthIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (monthSlider.count - 1) {
                createMonth = true
            }
        }
        .onChange(of: vm.isNewGroup, initial: false) { oldValue, newValue in
            if newValue {
                monthSlider.removeAll()
                currentMonthIndex = 1
                updateMonthScreenViewForNewGroup()
                vm.isNewGroup = false
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
}


