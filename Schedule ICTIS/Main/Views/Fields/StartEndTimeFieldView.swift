//
//  StartEndTimeView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 17.12.2024.
//

import SwiftUI

struct StartEndTimeFieldView: View {
    @Binding var isIncorrectDate: Bool
    @Binding var selectedDay: Date
    @Binding var selectedTime: Date
    var imageName: String
    var text: String
    @Binding var isTimeSelected: Bool
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(isIncorrectDate ? .red : Color("grayForFields"))
                .padding(.leading, 12)
                .padding(.trailing, 5)
            
            if !isTimeSelected || isIncorrectDate {
                Text(text)
                    .font(.custom("Montserrat-Meduim", fixedSize: 17))
                    .foregroundColor(.gray.opacity(0.5))
            }
            else {
                Text("\(selectedTime, formatter: timeFormatter)")
                    .foregroundColor(isIncorrectDate ? .red : .black)
                    .font(.custom("Montserrat-Medium", fixedSize: 17))
                    .padding(.trailing, 10)
            }
            Spacer()
        }
        .frame(width: (UIScreen.main.bounds.width / 2) - 22, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .overlay {
            if selectedDay.isToday {
                DatePicker("", selection: $selectedTime, in: Date()..., displayedComponents: .hourAndMinute)
                    .padding(.trailing, 35)
                    .blendMode(.destinationOver)
                    .onChange(of: selectedTime) { newValue, oldValue in
                        isTimeSelected = true
                    }
            }
            else {
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .padding(.trailing, 35)
                    .blendMode(.destinationOver)
                    .onChange(of: selectedTime) { newValue, oldValue in
                        isTimeSelected = true
                    }
            }
        }
    }
}
