//
//  SheetCreateClassView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 12.12.2024.
//

import SwiftUI

struct SheetCreateClassView: View {
    @Binding var isShowingSheet: Bool
    @State private var textForNameOfClass = ""
    @State private var textForNameOfAuditory = ""
    @State private var textForNameOfProfessor = ""
    @State private var isShowingDatePickerForDate: Bool = false
    @State private var isImportant: Bool = false
    @State private var selectedOptionForNotification: String = "Нет"
    @State private var selectedOptionForOnline: String = "Оффлайн"
    @State private var textForComment: String = ""
    @ObservedObject var vm: EditClassViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ProfessorAuditoryClassFieldView(text: $vm._class.subject, nameOfImage: "book", labelForField: "Предмет")
                        .padding(.bottom, 10)
                    ProfessorAuditoryClassFieldView(text: $vm._class.auditory, nameOfImage: "mappin.and.ellipse", labelForField: "Корпус-аудитория")
                        .padding(.bottom, 10)
                    ProfessorAuditoryClassFieldView(text: $vm._class.professor, nameOfImage: "book", labelForField: "Преподаватель")
                        .padding(.bottom, 10)
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 12)
                            .padding(.trailing, 7)
                        Text("Дата")
                            .foregroundColor(Color("grayForFields").opacity(0.5))
                            .font(.system(size: 18, weight: .regular))
                        Spacer()
                        Text("\(vm._class.day, formatter: dateFormatter)")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .medium))
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
                        StartEndTimeFieldView(selectedTime: $vm._class.starttime, imageName: "clock", text: "Начало")
                            .onChange(of: vm._class.starttime) { oldValue, newValue in
                                if !checkStartTimeLessThenEndTime(vm._class.starttime, vm._class.endtime) {
                                    print("Values \(oldValue) - \(newValue) 1")
                                    print(vm._class.starttime)
                                    vm._class.starttime = oldValue
                                }
                            }
                        Spacer()
                        StartEndTimeFieldView(selectedTime: $vm._class.endtime, imageName: "clock.badge.xmark", text: "Конец")
                            .onChange(of: vm._class.endtime) { oldValue, newValue in
                                print("Values \(oldValue) - \(newValue) 2")
                                print(vm._class.endtime)
                                validateTime(old: oldValue, new: newValue, isStartChanged: false)
                            }
                    }
                    .frame(height: 40)
                    .padding(.bottom, 10)
                    Toggle("Пометить как важную", isOn: $vm._class.important)
                        .frame(height: 40)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("Напоминанние")
                        Spacer()
                        Picker("Напоминание", selection: $vm._class.notification, content: {
                            ForEach(MockData.notifications, id: \.self) {
                                Text($0)
                            }
                        })
                        .accentColor(Color("grayForFields"))
                    }
                    .frame(height: 40)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
                    .padding(.bottom, 10)
                    HStack {
                        Text("Тип")
                        Spacer()
                        Picker("Тип", selection: $vm._class.online, content: {
                            ForEach(MockData.onlineOrOffline, id: \.self) {
                                Text($0)
                            }
                        })
                        .accentColor(Color("grayForFields"))
                    }
                    .frame(height: 40)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
                    .padding(.bottom, 10)
                    
                    CommentFieldView(textForComment: $vm._class.comment)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        isShowingSheet = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        do {
                            try vm.save()
                        } catch {
                            print(error)
                        }
                        isShowingSheet = false
                    }
                }
            }
            .navigationTitle("Новая пара")
            .background(Color("background"))
        }
    }
    func validateTime(old oldValue: Date, new newValue: Date, isStartChanged: Bool) {
        if !checkStartTimeLessThenEndTime(vm._class.starttime, vm._class.endtime) {
            if isStartChanged {
                vm._class.starttime = Date()
            } else {
                vm._class.starttime = Date()
            }
            print("Invalid time selected. Reverting to old value.")
        }
    }
}

#Preview {
    SheetCreateClassView(isShowingSheet: .constant(true), vm: .init(provider: .shared))
}
