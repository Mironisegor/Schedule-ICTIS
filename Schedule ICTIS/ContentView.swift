//
//  ContentView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 1
    @StateObject var vm = ViewModel()
    
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
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
                .tag(2)
        }
        .accentColor(Color("blueColor"))
    }
}

#Preview {
    ContentView()
}
