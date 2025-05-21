//
//  NetworkMonitor.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 27.03.2025.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = false
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                print(self?.isConnected == true ? "✅ Интернет подключен!" : "❌ Нет подключения к интернету.")
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    deinit {
        stopMonitoring()
    }
}
