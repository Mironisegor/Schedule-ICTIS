//
//  FirstLaunchScheduleView.swift
//  Schedule ICTIS
//
//  Created by G412 on 06.12.2024.
//

import SwiftUI

struct FirstLaunchScheduleView: View {
    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            HStack {
                Image(systemName: "pencil")
                    .font(.title)
                Text("Введите свою группу")
                    .font(.system(size: 20, weight: .bold, design: .default))
            }
            .foregroundColor(Color("blueColor"))
            Spacer()
        }
    }
}

#Preview {
    FirstLaunchScheduleView()
}
