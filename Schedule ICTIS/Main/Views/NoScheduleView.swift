//
//  NoScheduleView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 12.12.2024.
//

import SwiftUI

struct NoScheduleView: View {
    var body: some View {
        VStack {
            ScrollView (showsIndicators: false) {
                Text("Пока что расписания нет😪")
                    .padding(.top, 100)
                    .font(.custom("Montserrat-SemiBold", size: 17))
            }
        }
    }
}

#Preview {
    NoScheduleView()
}
