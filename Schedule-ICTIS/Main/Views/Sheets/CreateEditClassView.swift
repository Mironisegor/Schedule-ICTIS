//
//  SheetCreateClassView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 12.12.2024.
//

import SwiftUI

struct CreateEditClassView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingDatePickerForDate: Bool = false
    @ObservedObject var vm: EditClassViewModel
    var day: Date
    @State private var isIncorrectDate1: Bool = false
    @State private var isIncorrectDate2: Bool = false
    @State private var isShowingSubjectFieldRed: Bool = false
    @State private var isSelectedTime1 = false
    @State private var isSelectedTime2 = false
    @State private var textForLabelInSubjectField: String = "Предмет"
    @State private var selectedType: String = "Оффлайн"
    @FocusState private var isFocusedSubject: Bool
    @FocusState private var isFocusedAuditory: Bool
    @FocusState private var isFocusedProfessor: Bool
    @FocusState private var isFocusedComment: Bool
    var provider = ClassProvider.shared
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    SubjectFieldView(text: $vm._class.subject, isShowingSubjectFieldRed: $isShowingSubjectFieldRed, labelForField: $textForLabelInSubjectField, isFocused: _isFocusedSubject)
                        .padding(.bottom, 10)
                    
                    HStack {
                        HStack {
                            Text("Тип")
                                .font(.custom("Montserrat-Medium", fixedSize: 17))
                                .foregroundColor(.black)
                            Spacer()
                            HStack {
                                Text(vm._class.online)
                                    .font(.custom("Montserrat-Medium", fixedSize: 17))
                                    .foregroundColor(Color("customGray3"))
                                Image("upDownArrows")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                        .overlay {
                            HStack {
                                Spacer()
                                Picker("Тип", selection: $vm._class.online, content: {
                                    ForEach(MockData.onlineOrOffline, id: \.self) {
                                        Text($0)
                                    }
                                })
                                .accentColor(Color("grayForFields"))
                                .padding(.trailing, 35)
                                .blendMode(.destinationOver)
                            }
                            .frame(width: UIScreen.main.bounds.width)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    ZStack {
                        if vm._class.online == "Оффлайн" {
                            AuditoryFieldView(text: $vm._class.auditory, labelForField: "Корпус-аудитория", isFocused: _isFocusedAuditory)
                                .padding(.bottom, 10)
                                .transition(.asymmetric(
                                    insertion: .offset(y: -50).combined(with: .identity),
                                    removal: .offset(y: -50).combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(
                        vm._class.online == "Оффлайн" ?
                            .linear(duration: 0.3) : // Анимация для появления
                            .linear(duration: 0.2), // Анимация для исчезновения
                        value: vm._class.online
                    )
                    
                    ProfessorFieldView(text: $vm._class.professor, labelForField: "Преподаватель", isFocused: _isFocusedProfessor)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 12)
                            .padding(.trailing, 5)
                        Text("Дата")
                            .foregroundColor(Color("grayForFields").opacity(0.5))
                            .font(.custom("Montserrat-Meduim", fixedSize: 17))
                        Spacer()
                        Text("\(vm._class.day, formatter: dateFormatter)")
                            .foregroundColor(.black)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                            .padding(.trailing, 20)
                    }
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
                    .overlay {
                        DatePicker("", selection: $vm._class.day, in: Date()..., displayedComponents: .date)
                            .blendMode(.destinationOver)
    
                    }
                    .padding(.bottom, 10)
                    HStack {
                        StartEndTimeFieldView(isIncorrectDate: $isIncorrectDate1, selectedDay: $vm._class.day, selectedTime: $vm._class.starttime, imageName: "clock", text: "Начало", isTimeSelected: $isSelectedTime1)
                            .onChange(of: vm._class.starttime) { oldValue, newValue in
                                if !checkStartTimeLessThenEndTime(vm._class.starttime, vm._class.endtime) {
                                    self.isIncorrectDate1 = true
                                    self.isSelectedTime1 = false
                                    print("Первый")
                                    print(self.isSelectedTime1)
                                    print(self.isSelectedTime2)
                                }
                                else {
                                    self.isIncorrectDate1 = false
                                    self.isIncorrectDate2 = false
                                }
                            }
                        Spacer()
                        StartEndTimeFieldView(isIncorrectDate: $isIncorrectDate2, selectedDay: $vm._class.day, selectedTime: $vm._class.endtime, imageName: "clock.badge.xmark", text: "Конец", isTimeSelected: $isSelectedTime2)
                            .onChange(of: vm._class.endtime) { oldValue, newValue in
                                if !checkStartTimeLessThenEndTime(vm._class.starttime, vm._class.endtime) {
                                    self.isIncorrectDate2 = true
                                    self.isSelectedTime2 = false
                                    print("Второй")
                                    print(self.isSelectedTime1)
                                    print(self.isSelectedTime2)
                                }
                                else {
                                    self.isIncorrectDate1 = false
                                    self.isIncorrectDate2 = false
                                }
                            }
                    }
                    .frame(height: 40)
                    .padding(.bottom, 10)
                    Toggle("Пометить как важную", isOn: $vm._class.important)
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .frame(height: 40)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                        .padding(.bottom, 10)
                    
                    HStack {
                        HStack {
                            Text("Напоминание")
                                .font(.custom("Montserrat-Medium", fixedSize: 17))
                                .foregroundColor(.black)
                            Spacer()
                            HStack {
                                Text(vm._class.notification)
                                    .font(.custom("Montserrat-Medium", fixedSize: 17))
                                    .foregroundColor(Color("customGray3"))
                                Image("upDownArrows")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                        .overlay {
                            HStack {
                                Spacer()
                                Picker("", selection: $vm._class.notification   , content: {
                                    ForEach(MockData.notifications, id: \.self) {
                                        Text($0)
                                    }
                                })
                                .accentColor(Color("grayForFields"))
                                .padding(.trailing, 35)
                                .blendMode(.destinationOver)
                            }
                            .frame(width: UIScreen.main.bounds.width)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    CommentFieldView(textForComment: $vm._class.comment, isFocused: _isFocusedComment)
                        .padding(.bottom, 20)
                    
                    
                    if !vm.isNew {
                        Button {
                            do {
                                try provider.delete(vm._class, in: provider.viewContext)
                                dismiss()
                            } catch {
                                print(error)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "trash")
                                Text("Удалить занятие")
                                    .font(.custom("Montserrat-Medium", fixedSize: 17))
                                Spacer()
                            }
                            .frame(height: 40)
                            .background(Color.white)
                            .foregroundColor(Color.red)
                            .cornerRadius(10)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        isFocusedSubject = false
                        isFocusedProfessor = false
                        isFocusedAuditory = false
                        isFocusedComment = false
                        if (vm._class.subject.isEmpty || (isIncorrectDate1 || isIncorrectDate2) || (!isSelectedTime1 || !isSelectedTime2)) {
                            if (vm._class.subject.isEmpty) {
                                self.isShowingSubjectFieldRed = true
                                self.textForLabelInSubjectField = ""
                            }
                            if !isSelectedTime1 {
                                self.isIncorrectDate1 = true
                            }
                            if !isSelectedTime2 {
                                self.isIncorrectDate2 = true
                            }
                        }
                        else {
                            do {
                                try vm.save()
                                dismiss()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .navigationTitle(vm.isNew ? "Новая пара" : "Изменить данные")
            .background(Color("background"))
            .onAppear {
                let temp = Calendar.current.date(byAdding: .hour, value: 1, to: Date.init())
                if let endTime = temp {
                    if (!hoursMinutesAreEqual(date1: vm._class.starttime, isEqualTo: Date()) && !hoursMinutesAreEqual(date1: vm._class.endtime, isEqualTo: endTime)) {
                        self.isSelectedTime1 = true
                        self.isSelectedTime2 = true
                        print(vm._class.starttime)
                        print(vm._class.endtime)
                        print(endTime)
                        print(Date())
                    }
                }
                if day > Calendar.current.startOfDay(for: Date()) {
                    vm._class.day = day
                }
            }
            .onTapGesture {
                isFocusedSubject = false
                isFocusedProfessor = false
                isFocusedAuditory = false
                isFocusedComment = false
            }
        }
    }
}

#Preview {
    let day: Date = .init()
    CreateEditClassView(vm: .init(provider: .shared), day: day)
}
