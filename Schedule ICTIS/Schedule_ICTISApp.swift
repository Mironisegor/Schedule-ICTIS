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
    var provider = ClassProvider.shared
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm, networkMonitor: networkMonitor)
                .environment(\.managedObjectContext, ClassProvider.shared.viewContext)
                .onAppear {
                    vm.fillDictForVm()
                }
        }
    }
}
