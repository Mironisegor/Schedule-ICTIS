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
                print(52)
                vm.isNewGroup = false
            }
        }
    }
}

extension WeekTabView {
    func updateWeekScreenViewForNewGroup() {
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
    }
}

#Preview {
    ContentView()
}
