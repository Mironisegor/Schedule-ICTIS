//
//  LoadingAppView.swift
//  Schedule-ICTIS
//
//  Created by G412 on 06.06.2025.
//

import SwiftUI

struct LoadingAppView: View {
    // Параметры для настройки
    var imageSize: CGSize = CGSize(width: 200, height: 200)
    var progressBarHeight: CGFloat = 8
    var progressBarBackgroundColor: Color = Color.gray.opacity(0.3)
    
    // Состояние для прогресса загрузки
    @State private var progress: CGFloat = 0.0
    // Длительность загрузки (2 секунды)
    private let loadingDuration: TimeInterval = 2.0
    
    var body: some View {
        VStack(spacing: 30) {
            // Логотип
            Image("ICTIS_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageSize.width, height: imageSize.height)
                .padding(.bottom, 10)
            
            // Полоса загрузки
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Фон полосы
                    RoundedRectangle(cornerRadius: progressBarHeight/2)
                        .frame(width: geometry.size.width, height: progressBarHeight)
                        .foregroundColor(progressBarBackgroundColor)
                    
                    // Прогресс
                    RoundedRectangle(cornerRadius: progressBarHeight/2)
                        .frame(width: progress * geometry.size.width, height: progressBarHeight)
                        .foregroundColor(Color("blueColor"))
                        .animation(.linear(duration: loadingDuration), value: progress)
                }
            }
            .frame(height: progressBarHeight)
            .padding(.horizontal, 40)
            .padding(.top, 90)
        }
        .onAppear {
            // Запускаем анимацию загрузки
            startLoadingAnimation()
        }
    }
    
    private func startLoadingAnimation() {
        // Сбрасываем прогресс
        progress = 0.0
        
        // Анимируем до 100% за указанное время
        withAnimation(.linear(duration: loadingDuration)) {
            progress = 1.0
        }
    }
}

#Preview {
    LoadingAppView()
}
