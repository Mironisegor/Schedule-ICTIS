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
            let group1 = UserDefaults.standard.string(forKey: "group")
            let group2 = UserDefaults.standard.string(forKey: "group2")
            let group3 = UserDefaults.standard.string(forKey: "group3")
            if let nameGroup1 = group1, nameGroup1 != "" {
                vm.nameGroups.append(nameGroup1)
            }
            if let nameGroup2 = group2, nameGroup2 != ""  {
                vm.nameGroups.append(nameGroup2)
            }
            if let nameGroup3 = group3, nameGroup3 != "" {
                vm.nameGroups.append(nameGroup3)
            }
            print("\(group1) - \(group2) - \(group3)")
            vm.fetchWeekSchedule()
            if let vpkStr = UserDefaults.standard.string(forKey: "vpk") {
                vm.fetchWeekVPK(vpk: vpkStr)
            }
        }
    }
}

#Preview {
    ContentView()
}
