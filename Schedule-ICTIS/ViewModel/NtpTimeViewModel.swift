import Foundation
import Combine

final class TimeService: ObservableObject {
    static let shared = TimeService()
    
    @Published private(set) var isInitialSyncCompleted = false
    @Published private(set) var currentTime: Date = Date()
    @Published private(set) var isSynced: Bool = false
    @Published private(set) var error: Error?
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        startTimeUpdates()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func parseFormattedDate(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        return dateFormatter.date(from: str)
    }
    
    func syncTime() {
        Task {
            do {
                let date = try await NetworkManager.shared.getDate()
                await MainActor.run { // Обновляем UI в главном потоке
                    if let res = self.parseFormattedDate(str: date.formatted) {
                        self.currentTime = res
                        self.isSynced = true
                        self.error = nil
                        print("Время обновилось")
                    }
                }
            } catch {
                await MainActor.run { // Ошибки тоже в главном потоке
                    self.currentTime = Date()
                    self.isSynced = false
                    self.error = error
                }
            }
        }
    }
    
    private func startTimeUpdates() {
        syncTime()
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 30,
            repeats: true
        ) { [weak self] _ in
            self?.syncTime()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isInitialSyncCompleted = true
        }
    }
}
