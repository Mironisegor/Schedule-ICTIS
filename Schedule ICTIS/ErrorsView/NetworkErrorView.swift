//
//  NetworkErrorView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 26.03.2025.
//

import SwiftUI

struct NetworkErrorView: View {
    var message: String
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 60, weight: .light))
                    .frame(width: 70, height: 70)
                Text(message)
                    .font(.custom("Montserrat-Medium", fixedSize: 15))
                    .padding(.top, 5)
            }
            .padding(.horizontal, 30)
            Spacer()
        }
    }
}

#Preview {
    NetworkErrorView(message: "Восстановите подключение к интернету чтобы мы смогли загрузить расписание")
}
