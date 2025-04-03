//
//  ContentView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 1
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tasks")
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Задания")
                }
                .tag(0)
            
            MainView(vm: vm, networkMonitor: networkMonitor)
                .tabItem {
                    Image(systemName: "house")
                    Text("Расписание")
                }
                .tag(1)
            
            SettingsView(vm: vm)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
                .tag(2)
        }
        .accentColor(Color("blueColor"))
        .onAppear {
            vm.fetchWeekSchedule()
        }
    }
}
