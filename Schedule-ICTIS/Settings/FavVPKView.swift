//
//  FavGroupsView.swift
//  Schedule ICTIS
//
//  Created by Egor Mironov on 05.03.2025.
//

import SwiftUI

struct FavVPKView: View {
    @Environment(\.dismiss) private var dismiss
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
        }
        .navigationBarBackButtonHidden(true)
        .background(Color("background"))
        .simultaneousGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    // Проверяем, что свайп начинается у левого края и идёт вправо
                    if value.startLocation.x < 20 && value.translation.width > 80 {
                        dismiss()
                    }
                }
        )
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Настройки")
                    }
                    .foregroundColor(.blue)
                }
            }
            // Кнопка в правой части
            ToolbarItem(placement: .topBarTrailing) {
                if favVpk.count < 5 {
                    NavigationLink(destination: SelectingVPKView(vm: vm, networkMonitor: networkMonitor)) {
                        ZStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color("blueColor"))
                                .cornerRadius(10)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    @Previewable @StateObject var vm2 = NetworkMonitor()
    FavVPKView(vm: vm, networkMonitor: vm2)
}
