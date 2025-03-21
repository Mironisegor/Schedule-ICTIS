//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 05.12.2024.
// ктбо2-6

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var vm: ScheduleViewModel
    @FetchRequest(fetchRequest: ClassModel.all()) private var classes  // Делаем запрос в CoreData и получаем список сохраненных пар
    @State private var selectedClass: ClassModel? = nil
    @State private var lastOffset: CGFloat = 0
    @State private var scrollTimer: Timer? = nil
    @State private var isShowingMyPairs = false
    @Binding var isScrolling: Bool
    var provider = ClassProvider.shared
    var body: some View {
        if vm.isLoading {
            LoadingScheduleView()
        }
        else {
            if vm.errorInNetwork != .invalidResponse {
                ZStack (alignment: .top) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack (spacing: 30) {
                            VStack (alignment: .leading, spacing: 10) {
                                ForEach(0..<vm.classesGroups.count, id: \.self) { dayIndex in
                                    if dayIndex == vm.selectedIndex {
                                        ForEach(vm.classesGroups[dayIndex]) { info in
                                            VStack (alignment: .trailing) {
                                                Text(info.group)
                                                    .font(.custom("Montserrat-Regular", fixedSize: 11))
                                                    .foregroundColor(Color("grayForNameGroup"))
                                                HStack(spacing: 15) {
                                                    VStack {
                                                        Text(convertTimeString(info.time)[0])
                                                            .font(.custom("Montserrat-Regular", fixedSize: 15))
                                                            .padding(.bottom, 1)
                                                        Text(convertTimeString(info.time)[1])
                                                            .font(.custom("Montserrat-Regular", fixedSize: 15))
                                                            .padding(.top, 1)
                                                    }
                                                    .frame(width: 48)
                                                    .padding(.top, 7)
                                                    .padding(.bottom, 7)
                                                    .padding(.leading, 10)
                                                    Rectangle()
                                                        .frame(width: 2)
                                                        .frame(maxHeight: UIScreen.main.bounds.height - 18)
                                                        .padding(.top, 7)
                                                        .padding(.bottom, 7)
                                                        .foregroundColor(getColorForClass(info.subject))
                                                    Text(info.subject)
                                                        .font(.custom("Montserrat-Medium", fixedSize: 16))
                                                        .lineSpacing(3)
                                                        .padding(.top, 9)
                                                        .padding(.bottom, 9)
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
                            }
                            if classes.contains(where: { daysAreEqual($0.day, vm.selectedDay) }) {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Мои пары")
                                        .font(.custom("Montserrat-Bold", fixedSize: 20))
                                    ForEach(classes) { _class in
                                        if daysAreEqual(_class.day, vm.selectedDay) {
                                            CreatedClassView(_class: _class)
                                                .onTapGesture {
                                                    selectedClass = _class
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.bottom, 100)
                        .padding(.top, 10)
                        .background(GeometryReader { geometry in
                                Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                            })
                    }
                    .onPreferenceChange(ViewOffsetKey.self) { offset in
                        if offset != lastOffset {
                            // Скролл происходит
                            isScrolling = true

                            // Останавливаем предыдущий таймер
                            scrollTimer?.invalidate()
                            // Запускаем новый таймер
                            scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                // Скролл остановился
                                isScrolling = false
                            }
                        }
                        lastOffset = offset
                    }
                    .onDisappear {
                        scrollTimer?.invalidate()
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
                    CreateEditClassView(vm: .init(provider: provider, _class: _class), day: vm.selectedDay)
                })
            }
            else {
                NoScheduleView()
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

#Preview {
    ContentView()
}
