//
//  FavGroupsView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 05.03.2025.
//

import SwiftUI
import CoreData

struct FavGroupsView: View {
    @Environment(\.dismiss) private var dismiss
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
        }
        .navigationBarBackButtonHidden(true)
        .background(Color("background"))
        // Жест для возврата на страницу настроек
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
                if favGroups.count < 10 {
                    NavigationLink(destination: SelectingGroupView(vm: vm, networkMonitor: networkMonitor)) {
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
    FavGroupsView(vm: vm, networkMonitor: vm2)
}
