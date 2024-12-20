//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by G412 on 05.12.2024.
//

import SwiftUI

struct ScheduleView: View {
    @State private var isShowingSheet: Bool = false
    @ObservedObject var vm: ScheduleViewModel
    @FetchRequest(fetchRequest: ClassModel.all()) private var classes
    var body: some View {
        if vm.isLoading {
            LoadingView(isLoading: $vm.isLoading)
        }
        else {
            if vm.errorInNetwork != .invalidResponse {
                ZStack (alignment: .top) {
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
                                                    .foregroundColor(getColorForClass(lesson))
                                                Text(lesson)
                                                    .font(.system(size: 18, weight: .regular))
                                                    .padding(.top, 7)
                                                    .padding(.bottom, 7)
                                                Spacer()
                                            }
                                            .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 230)
                                            .background(Color.white)
                                            .cornerRadius(20)
                                            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                                            .onTapGesture {
                                                isShowingSheet = true
                                            }
                                        }
                                    }
                                }
                            }
                            ForEach(classes) { _class in
                                if datesAreEqual(_class.day, vm.selectedDay) {
                                    HStack(spacing: 10) {
                                        VStack {
                                            Text(getTimeString(_class.starttime))
                                                .font(.system(size: 15, weight: .regular))
                                            Text(getTimeString(_class.endtime))
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
                                            .foregroundColor(_class.important ? Color("redForImportant") : onlineOrNot(_class.online))
                                        Text(getSubjectName(_class.subject, _class.professor, _class.auditory))
                                            .font(.system(size: 18, weight: .regular))
                                            .padding(.top, 7)
                                            .padding(.bottom, 7)
                                        Spacer()
                                    }
                                    .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 230)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                                    .onTapGesture {
                                        isShowingSheet = true
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.bottom, 100)
                        .padding(.top, 30)
                    }
                    VStack {
                        LinearGradient(gradient: Gradient(colors: [Color("background").opacity(0.95), Color.white.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 15)
                }
                .sheet(isPresented: $isShowingSheet) {
                    SheetChangeClassView(isShowingSheet: $isShowingSheet)
                }
            }
            else {
                NoScheduleView()
            }
        }
    }
}

#Preview {
    ContentView()
}
