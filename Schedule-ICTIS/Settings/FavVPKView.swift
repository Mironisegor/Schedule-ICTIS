//
//  FavGroupsView.swift
//  Schedule ICTIS
//
//  Created by Egor Mironov on 05.03.2025.
//

import SwiftUI

struct FavVPKView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    @FetchRequest(fetchRequest: FavouriteVpkModel.all()) private var favVpk     // Список ВПК сохраненных в CoreData
    var provider = ClassProvider.shared
    var body: some View {
        VStack (spacing: 0) {
            List {
                ForEach(favVpk, id: \.self) {favVpk in
                    HStack {
                        Text(favVpk.name)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vm.removeFromSchedule(group: favVpk.name)
                            do {
                                try JsonClassModel.deleteClasses(withName: favVpk.name, in: provider.viewContext)
                                try provider.delete(favVpk, in: provider.viewContext)
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
                if favVpk.count < 5 {
                    NavigationLink(destination: SelectingVPKView(vm: vm, networkMonitor: networkMonitor)) {
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
    FavVPKView(vm: vm, networkMonitor: vm2)
}
