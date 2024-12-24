//
//  SheetCreateClassView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 12.12.2024.
//

import SwiftUI

struct CreateClassView: View {
    @Binding var isShowingSheet: Bool
    @State private var isShowingDatePickerForDate: Bool = false
    @ObservedObject var vm: EditClassViewModel
    @State private var isIncorrectDate1: Bool = false
    @State private var isIncorrectDate2: Bool = false
    
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
                        StartEndTimeFieldView(isIncorrectDate: $isIncorrectDate1, selectedDay: $vm._class.day, selectedTime: $vm._class.starttime, imageName: "clock", text: "Начало")
                            .onChange(of: vm._class.starttime) { oldValue, newValue in
                                if !checkStartTimeLessThenEndTime(vm._class.starttime, vm._class.endtime) {
                                    self.isIncorrectDate1 = true
                                }
                                else {
                                    self.isIncorrectDate1 = false
                                    self.isIncorrectDate2 = false
                                }
                            }
                            .overlay {
                                if isIncorrectDate1 {
                                    Rectangle()
                                        .frame(maxWidth: 300, maxHeight: 1)
                                        .foregroundColor(.red)
                                        .padding(.horizontal)
                                }
                            }
                        Spacer()
                        StartEndTimeFieldView(isIncorrectDate: $isIncorrectDate2, selectedDay: $vm._class.day, selectedTime: $vm._class.endtime, imageName: "clock.badge.xmark", text: "Конец")
                            .onChange(of: vm._class.endtime) { oldValue, newValue in
                                if !checkStartTimeLessThenEndTime(vm._class.starttime, vm._class.endtime) {
                                    self.isIncorrectDate2 = true
                                }
                                else {
                                    self.isIncorrectDate1 = false
                                    self.isIncorrectDate2 = false
                                }
                            }
                            .overlay {
                                if isIncorrectDate2 {
                                    Rectangle()
                                        .frame(maxWidth: 300, maxHeight: 1)
                                        .foregroundColor(.red)
                                        .padding(.horizontal)
                                }
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
    func checkStartTimeLessThenEndTime(_ startTime: Date, _ endTime: Date) -> Bool {
        let calendar = Calendar.current
        
        let firstComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let secondComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        guard let startHours = firstComponents.hour, let startMinutes = firstComponents.minute else {
            return false
        }
        guard let endHours = secondComponents.hour, let endMinutes = secondComponents.minute else {
            return false
        }
        
        print("\(startHours) - \(endHours)")
        print("\(startMinutes) - \(endMinutes)")
        if Int(startHours) > Int(endHours) {
            return false
        }
        else if startHours == endHours {
            if startMinutes < endMinutes {
                return true
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }
}

#Preview {
    CreateClassView(isShowingSheet: .constant(true), vm: .init(provider: .shared))
}
