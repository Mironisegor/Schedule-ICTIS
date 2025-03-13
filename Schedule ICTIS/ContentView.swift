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
            fillDictForVm()
            vm.fetchWeekSchedule()
        }
    }
    
    func fillDictForVm() {
        let group1 = UserDefaults.standard.string(forKey: "group")
        let group2 = UserDefaults.standard.string(forKey: "group2")
        let group3 = UserDefaults.standard.string(forKey: "group3")
        let vpk1 = UserDefaults.standard.string(forKey: "vpk1")
        let vpk2 = UserDefaults.standard.string(forKey: "vpk2")
        let vpk3 = UserDefaults.standard.string(forKey: "vpk3")
        if let nameGroup1 = group1, nameGroup1 != "" {
            vm.nameToHtml[nameGroup1] = ""
        }
        if let nameGroup2 = group2, nameGroup2 != ""  {
            vm.nameToHtml[nameGroup2] = ""
        }
        if let nameGroup3 = group3, nameGroup3 != "" {
            vm.nameToHtml[nameGroup3] = ""
        }
        if let nameVpk1 = vpk1, nameVpk1 != "" {
            vm.nameToHtml[nameVpk1] = ""
        }
        if let nameVpk2 = vpk2, nameVpk2 != "" {
            vm.nameToHtml[nameVpk2] = ""
        }
        if let nameVpk3 = vpk3, nameVpk3 != "" {
            vm.nameToHtml[nameVpk3] = ""
        }
    }
}

#Preview {
    ContentView()
}
