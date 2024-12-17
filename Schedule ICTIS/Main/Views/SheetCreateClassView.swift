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
    @State private var selectedDay: Date = Date()
    @State private var selectedStartTime: Date = Date()
    @State private var selectedEndTime: Date = Date()
    @State private var isImportant: Bool = false
    @State private var selectedOption: String = "Нет"
    @State private var textForComment: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    FieldView(text: $textForNameOfClass, nameOfImage: "book", labelForField: "Предмет")
                        .padding(.bottom, 10)
                    FieldView(text: $textForNameOfAuditory, nameOfImage: "mappin.and.ellipse", labelForField: "Корпус-аудитория")
                        .padding(.bottom, 10)
                    FieldView(text: $textForNameOfProfessor, nameOfImage: "book", labelForField: "Преподаватель")
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
                        Text("\(selectedDay, formatter: dateFormatter)")
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
                        DatePicker("", selection: $selectedDay, in: Date()..., displayedComponents: .date)
                            .blendMode(.destinationOver)
                    }
                    .padding(.bottom, 10)
                    HStack {
                        StartEndTimeView(selectedTime: $selectedStartTime, imageName: "clock", text: "Начало")
                        Spacer()
                        StartEndTimeView(selectedTime: $selectedEndTime, imageName: "clock.badge.xmark", text: "Конец")
                    }
                    .frame(height: 40)
                    .padding(.bottom, 10)
                    Toggle("Пометить как важную", isOn: $isImportant)
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
                        Picker("Напоминание", selection: $selectedOption, content: {
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
                    
                    CommentView(textForComment: $textForComment)
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
                        isShowingSheet = false
                    }
                }
            }
            .navigationTitle("Новая пара")
            .background(Color("background"))
        }
    }
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
    }
}

#Preview {
    SheetCreateClassView(isShowingSheet: .constant(true))
}
