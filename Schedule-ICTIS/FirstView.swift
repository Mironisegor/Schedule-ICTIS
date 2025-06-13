//
//  FirstView.swift
//  Schedule-ICTIS
//
//  Created by G412 on 06.06.2025.
//

import SwiftUI

struct FirstView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var timeService: TimeService
    var body: some View {
        ZStack {
            if !timeService.isInitialSyncCompleted {
                LoadingAppView()
            } else {
                ContentView(vm: vm, networkMonitor: networkMonitor)
            }
        }
        .onAppear {
            fillDictForVm()
            vm.fetchWeekSchedule()
            vm.fillFilteringGroups()
        }
    }
}

extension FirstView {
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
