//
//  LoadingView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 11.12.2024.
//

import SwiftUI

struct ConnectingToNetworkView: View {
    @State private var isAnimating = false
    var body: some View {
        VStack {
            Text("Ожидание сети")
                .font(.custom("Montserrat-Medium", fixedSize: 18))
            Circle()
                .trim(from: 0.2, to: 1.0)
                .stroke(Color("blueColor"), lineWidth: 3)
                .frame(width: 30, height: 30)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 0.6).repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .onAppear { isAnimating = true }
        }
    }
}

#Preview {
    ConnectingToNetworkView()
}
