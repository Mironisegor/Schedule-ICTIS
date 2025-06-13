import Foundation
import TrueTime
import Combine

final class TimeService: ObservableObject {
    static let shared = TimeService()
    private let trueTimeClient = TrueTimeClient.sharedInstance
    
    // Добавляем флаг начальной синхронизации
    @Published var isInitialSyncCompleted = false
    @Published var currentTime: Date = Date()
    @Published var isSynced: Bool = false
    @Published var error: Error?
    
    private var timer: Timer?
    
    init() {
        trueTimeClient.start()
        startTimeUpdates()
    }
    
    func syncTime(completion: (() -> Void)? = nil) {
        trueTimeClient.fetchIfNeeded { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let referenceTime):
                    self?.currentTime = referenceTime.now()
                    self?.isSynced = true
                    self?.error = nil
                    print("✅ Время синхронизировано")
                case .failure(let error):
                    self?.error = error
                    self?.isSynced = false
                    self?.currentTime = Date() // Fallback
                    print("❌ Не удалось выполнить синхронизацию")
                }
                completion?()
                if self?.isInitialSyncCompleted == false {
                    self?.isInitialSyncCompleted = true
                }
            }
        }
    }
    
    private func startTimeUpdates() {
        // Первоначальная синхронизация
        syncTime()
        
        // Обновление каждую минуту
        timer = Timer.scheduledTimer(
            withTimeInterval: 10,
            repeats: true
        ) { [weak self] _ in
            self?.syncTime()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
