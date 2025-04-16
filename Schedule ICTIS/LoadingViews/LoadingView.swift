//
//  LoadingView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 04.04.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
        
    var body: some View {
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

#Preview {
    LoadingView()
}
