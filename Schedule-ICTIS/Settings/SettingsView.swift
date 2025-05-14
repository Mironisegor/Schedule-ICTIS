//
//  SettingsView2.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 25.02.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    @State private var selectedTheme = "Светлая"
    @State private var selectedLanguage = "Русский"
    var body: some View {
        NavigationView {
            VStack {
                ScrollView (.vertical, showsIndicators: false) {
                    VStack (alignment: .leading) {
                        Text("Общие")
                            .font(.custom("Montserrat-Medium", fixedSize: 18))
                            .foregroundColor(Color("customGray3"))
                            .padding(.horizontal)
                        GeneralGroupSettings(selectedTheme: $selectedTheme, selectedLanguage: $selectedLanguage)
                    }
                    .padding(.top, 20)
                    VStack (alignment: .leading) {
                        Text("Расписание")
                            .font(.custom("Montserrat-Medium", fixedSize: 18))
                            .foregroundColor(Color("customGray3"))
                            .padding(.horizontal)
                        ScheduleGroupSettings(vm: vm, networkMonitor: networkMonitor)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal)
            }
            .background(Color("background"))
            .navigationTitle("Настройки")
        }
    }
}


#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    @Previewable @StateObject var vm2 = NetworkMonitor()
    SettingsView(vm: vm, networkMonitor: vm2)
}
