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
    @State private var isTimeSelected: Bool = false
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(isIncorrectDate ? .red : Color("grayForFields"))
                .padding(.leading, 12)
            
            if !isTimeSelected {
                Text(text)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            if isTimeSelected {
                Text("\(selectedTime, formatter: timeFormatter)")
                    .foregroundColor(isIncorrectDate ? .red : .black)
                    .font(.system(size: 17, weight: .medium))
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
            if isSameDate(selectedTime, selectedDay) {
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
