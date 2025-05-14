//
//  WeekTabView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 10.12.2024.
//

import SwiftUI

struct WeekTabView: View {
    @State private var currentWeekIndex: Int = 1
    @State var weekSlider: [[Date.WeekDay]] = []
    @State private var createWeek: Bool = false
    @ObservedObject var vm: ScheduleViewModel
    var body: some View {
        HStack {
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekViewForWeek(weekSlider: $weekSlider, currentWeekIndex: $currentWeekIndex, createWeek: $createWeek, week: week, vm: vm)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .onAppear(perform: {
            updateWeekScreenViewForNewGroup()
        })
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
        .onChange(of: vm.isNewGroup, initial: false) { oldValue, newValue in
            if newValue {
                weekSlider.removeAll()
                currentWeekIndex = 1
                updateWeekScreenViewForNewGroup()
                vm.isNewGroup = false
            }
        }
    }
}
