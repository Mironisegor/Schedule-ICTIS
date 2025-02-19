//
//  SettingsView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 30.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: ScheduleViewModel
    @State private var selectedTheme = "Светлая"
    @State private var selectedLanguage = "Русский"
    @AppStorage("group") private var favGroup = ""
    @AppStorage("vpk") private var favVPK = ""
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("Общие") {
                        Picker("Тема", selection: $selectedTheme, content: {
                            ForEach(MockData.themes, id: \.self) {
                                Text($0)
                            }
                        })
                        Picker("Язык", selection: $selectedLanguage, content: {
                            ForEach(MockData.languages, id: \.self) {
                                Text($0)
                            }
                        })
                    }
                    Section("Расписание") {
                        NavigationLink(destination: SelectingGroupView(vm: vm)) {
                            LabeledContent {
                                Text(favGroup)
                            } label: {
                                Text("Избранное расписание")
                            }
                        }
                        NavigationLink(destination: SelectingVPKView(vm: vm)) {
                            LabeledContent {
                                Text(favVPK)
                            } label: {
                                Text("Избранное ВПК")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Настройки")
        }
    }
}

#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    SettingsView(vm: vm)
}
