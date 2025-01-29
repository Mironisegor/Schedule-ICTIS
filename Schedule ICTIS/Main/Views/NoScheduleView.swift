//
//  NoScheduleView.swift
//  Schedule ICTIS
//
//  Created by G412 on 12.12.2024.
//

import SwiftUI

struct NoScheduleView: View {
    var body: some View {
        VStack {
            ScrollView (showsIndicators: false) {
                Text("Пока расписания нет")
                    .padding(.top, 20)
                    .font(.custom("Montserrat-Regular", size: 15))
            }
        }
    }
}

#Preview {
    NoScheduleView()
}
