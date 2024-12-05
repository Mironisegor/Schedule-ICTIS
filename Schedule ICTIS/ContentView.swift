//
//  ContentView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabBarModel = .schedule
    var body: some View {
        ZStack {
            switch selectedTab {
            case .schedule:
                MainView()
            case .tasks:
                Text("Tasks")
            case .settings:
                Text("Settings")
            }
            TabBarView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
