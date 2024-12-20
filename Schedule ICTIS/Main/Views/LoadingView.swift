//
//  LoadingView.swift
//  Schedule ICTIS
//
//  Created by G412 on 11.12.2024.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                .scaleEffect(1)
        }
    }
}

#Preview {
    LoadingView(isLoading: .constant(true))
}
