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
            VStack (spacing: 20) {
                ForEach(vm.classes.indices, id: \.self) { index in
                    if index != 0 && index != 1 && index == vm.selectedIndex {
                        let daySchedule = vm.classes[index] // Это массив строк для дня
                        ForEach(daySchedule.indices.dropFirst(), id: \.self) { lessonIndex in
                            let lesson = daySchedule[lessonIndex] // Это строка с расписанием одной пары
                            if !lesson.isEmpty {
                                HStack(spacing: 10) {
                                    VStack {
                                        Text(convertTimeString(vm.classes[1][lessonIndex])[0])
                                            .font(.system(size: 15, weight: .regular))
                                        Text(convertTimeString(vm.classes[1][lessonIndex])[1])
                                            .font(.system(size: 15, weight: .regular))
                                    }
                                    .padding(.top, 7)
                                    .padding(.bottom, 7)
                                    .padding(.leading, 10)
                                    Rectangle()
                                        .frame(width: 2)
                                        .frame(maxHeight: UIScreen.main.bounds.height - 18)
                                        .padding(.top, 7)
                                        .padding(.bottom, 7)
                                        .foregroundColor(onlineOrOffline(lesson) ? Color("greenForOffline") : Color("blueForOnline"))
                                    Text(lesson)
                                        .font(.system(size: 18, weight: .regular))
                                        .padding(.top, 7)
                                        .padding(.bottom, 7)
                                    Spacer()
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 230)
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 100)
            .padding(.top, 10)
        }
    }
    //ктбо2-6
    
    func convertTimeString(_ input: String) -> [String] {
        let parts = input.split(separator: "-")
        if let firstPart = parts.first, let lastPart = parts.last {
            return [String(firstPart), String(lastPart)]
        } else {
            return []
        }
    }
    
    func onlineOrOffline(_ str: String) -> Bool {
        if (MockData.onlineClasses.contains(str)) {
            return false
        }
        else {
            return true
        }
    }
}

#Preview {
    ContentView()
}
