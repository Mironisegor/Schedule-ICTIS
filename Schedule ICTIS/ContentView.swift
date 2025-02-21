//
//  ContentView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 1
    @StateObject var vm = ScheduleViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tasks")
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Задания")
                }
                .tag(0)
            
            MainView(vm: vm)
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
            let group = UserDefaults.standard.string(forKey: "group")
            if let nameGroup = group {
                vm.group = nameGroup
                vm.fetchWeekSchedule(group: nameGroup)
            }
            if let vpkStr = UserDefaults.standard.string(forKey: "vpk") {
                vm.fetchWeekVPK(vpk: vpkStr)
            }
            print(vm.vpks)
        }
    }
}

#Preview {
    ContentView()
}
