//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by G412 on 05.12.2024.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (spacing: 12) {
                ForEach(vm.classes.indices, id: \.self) { index in
                    if index != 0 && index != 1 && index == vm.selectedIndex {
                        let daySchedule = vm.classes[index] // Это массив строк для дня
                        ForEach(daySchedule.indices.dropFirst(), id: \.self) { lessonIndex in
                            let lesson = daySchedule[lessonIndex] // Это строка с расписанием одной пары
                            if !lesson.isEmpty {
                                HStack(spacing: 6) {
                                    VStack {
                                        Text(convertTimeString(vm.classes[1][lessonIndex])[0])
                                            .font(.system(size: 15, weight: .light))
                                        Text(convertTimeString(vm.classes[1][lessonIndex])[1])
                                            .font(.system(size: 15, weight: .light))
                                    }
                                    Rectangle()
                                        .frame(width: 2)
                                        .frame(maxHeight: 100)
                                    Text(lesson)
                                }
                                .background(Color.white)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
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
    MainView()
}
