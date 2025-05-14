//
//  FavGroupsView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 05.03.2025.
//

import SwiftUI
import CoreData

struct FavGroupsView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    @FetchRequest(fetchRequest: FavouriteGroupModel.all()) private var favGroups     // Список групп сохраненных в CoreData
    var provider = ClassProvider.shared
    var body: some View {
        VStack (spacing: 0) {
            List {
                ForEach(favGroups, id: \.self) {favGroup in
                    HStack {
                        Text(favGroup.name)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vm.removeFromSchedule(group: favGroup.name)
                            do {
                                try JsonClassModel.deleteClasses(withName: favGroup.name, in: provider.viewContext)
                                try provider.delete(favGroup, in: provider.viewContext)
                            } catch {
                                print(error)
                            }
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
            }
            
            Spacer()
                        
            HStack {
                Spacer()
                if favGroups.count < 10 {
                    NavigationLink(destination: SelectingGroupView(vm: vm, networkMonitor: networkMonitor)) {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                        }
                        .background(Color("blueColor"))
                        .cornerRadius(10)
                        .padding(.trailing, 20)
                    }
                }
            }
            .padding(.bottom, 90)
        }
        .background(Color("background"))
    }
}

#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    @Previewable @StateObject var vm2 = NetworkMonitor()
    FavGroupsView(vm: vm, networkMonitor: vm2)
}
