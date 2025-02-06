//
//  SettingsView.swift
//  Schedule ICTIS
//
//  Created by G412 on 30.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: ScheduleViewModel
    @State private var selectedTheme = "Светлая"
    @State private var selectedLanguage = "Русский"
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
                        NavigationLink(destination: SelectingGroupView(group: $vm.group)) {
                            LabeledContent {
                                Text(vm.group)
                            } label: {
                                Text("Избранное расписание")
                            }
                        }
                        NavigationLink(destination: SelectingVPKView()) {
                            LabeledContent {
                            } label: {
                                Text("ВПК")
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
