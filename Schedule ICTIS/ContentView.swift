//
//  ContentView.swift
//  Schedule ICTIS
//
//  Created by G412 on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isActiveTabBar: TabModel = .schedule
    @State private var isTabBarHidden: Bool = false
    var body: some View {
        VStack {
            TabView(selection: $isActiveTabBar) {
                ScheduleView()
                    .tag(TabModel.schedule)
                Text("Tasks")
                    .tag(TabModel.tasks)
                Text("Settings")
                    .tag(TabModel.settings)
            }
            CustomTabBarView(isActiveTabBar: $isActiveTabBar)
                .padding(.bottom, 10)
        }
        .background(.secondary.opacity(0.15))
    }
}

#Preview {
    ContentView()
}
