//
//  Schedule_ICTISApp.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

@main
struct Schedule_ICTISApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject var vm = ScheduleViewModel()
    @StateObject var timeService = TimeService.shared
    var body: some Scene {
        WindowGroup {
            FirstView(vm: vm, networkMonitor: networkMonitor)
                .environment(\.managedObjectContext, ClassProvider.shared.viewContext)
                .environmentObject(timeService)
        }
    }
}
