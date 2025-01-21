//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 05.12.2024.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var vm: ScheduleViewModel
    @FetchRequest(fetchRequest: ClassModel.all()) private var classes  //Делаем запрос в CoreData и получаем список сохраненных пар
    @State private var selectedClass: ClassModel? = nil
    var provider = ClassProvider.shared
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
                                        }
                                    }
                                }
                            }
                            ForEach(classes) { _class in
                                if daysAreEqual(_class.day, vm.selectedDay) {
                                    CreatedClassView(_class: _class)
                                        .onTapGesture {
                                            selectedClass = _class
                                            print(selectedClass)
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
                //Sheet будет открываться, когда selectedClass будет становиться не nil
                .sheet(item: $selectedClass,
                       onDismiss: {
                    selectedClass = nil
                },
                       content: { _class in
                    CreateEditClassView(vm: .init(provider: provider, _class: _class))
                })
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
