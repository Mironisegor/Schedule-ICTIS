//
//  ContentView.swift
//  Schedule ICTIS
//
//  Created by G412 on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabModel = .schedule
    var body: some View {
        ZStack {
            switch selectedTab {
            case .schedule:
                ScheduleView()
            case .tasks:
                Text("Tasks")
            case .settings:
                Text("Settings")
            }
            TabBarView(selectedTab: $selectedTab)
        }
        .background(.secondary.opacity(0.15))
    }
}

#Preview {
    ContentView()
}
