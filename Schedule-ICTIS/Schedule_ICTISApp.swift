//
//  Schedule_ICTISApp.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

@main
struct Schedule_ICTISApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject var vm = ScheduleViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm, networkMonitor: networkMonitor)
                .environment(\.managedObjectContext, ClassProvider.shared.viewContext)
                .onAppear {
                    fillDictForVm()
                }
        }
    }
}

extension Schedule_ICTISApp {
    func fillDictForVm() {
        let context = ClassProvider.shared.viewContext
        
        do {
            // Используем ваш метод all() для групп
            let groupRequest = FavouriteGroupModel.all()
            let groups = try context.fetch(groupRequest)
            for group in groups {
                vm.nameToHtml[group.name] = ""
            }
            
            // Аналогично для ВПК (предполагая, что у вас есть аналогичный метод)
            let vpkRequest = FavouriteVpkModel.all()
            let vpks = try context.fetch(vpkRequest)
            for vpk in vpks {
                vm.nameToHtml[vpk.name] = ""
            }
        } catch {
            print("Ошибка при загрузке данных: \(error.localizedDescription)")
        }
    }
}
