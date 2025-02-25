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
    @Binding var isShowingVPKLabel: Bool
    var body: some View {
        VStack {
            HStack (spacing: 34) {
                ForEach(MockData.daysOfWeek.indices, id: \.self) { index in
                    Text(MockData.daysOfWeek[index])
                        .font(.custom("Montserrat-SemiBold", fixedSize: 15))
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
            updateMonthScreenViewForNewGroup()
        })
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
                WeekViewForMonth(week: week, vm: vm, isShowingVPKLabel: $isShowingVPKLabel)
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


#Preview {
    ContentView()
}
