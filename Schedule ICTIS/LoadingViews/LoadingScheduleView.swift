import SwiftUI

struct LoadingScheduleView: View {
    @State private var isAnimated = false
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack (alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            isAnimated ? Color.gray.opacity(0.6) : Color.gray.opacity(0.3),
                                            isAnimated ? Color.gray.opacity(0.3) : Color.gray.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 45, height: 20)
                                .padding(.horizontal, 20)
                                .animation(.linear(duration: 0.8).repeatForever(autoreverses: true), value: isAnimated)
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            isAnimated ? Color.gray.opacity(0.6) : Color.gray.opacity(0.3),
                                            isAnimated ? Color.gray.opacity(0.3) : Color.gray.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 70)
                                .padding(.horizontal, 20)
                                .animation(.linear(duration: 0.8).repeatForever(autoreverses: true), value: isAnimated)
                            }
                        }
                    }
                    .onAppear {
                        isAnimated.toggle()
                    }
                    .padding(.top, 10)
            }
        }
    }
}

#Preview {
    LoadingScheduleView()
}
