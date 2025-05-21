//
//  FilterGroupsView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 21.03.2025.
//

import SwiftUI

struct FilterGroupsView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                // Кнопка добавления новой группы
                NavigationLink(destination: SelectingGroupView(vm: vm, networkMonitor: networkMonitor)) {
                    ZStack {
                        Rectangle()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(.white)
                            .cornerRadius(20)
                        Image(systemName: "plus")
                            .foregroundColor(Color("customGray3"))
                            .font(.system(size: 12))
                    }
                }
                
                if vm.filteringGroups.count == 2 {
                    ForEach(vm.filteringGroups.dropFirst(), id: \.self) { group in
                        GroupItem(group: group, isSelected: vm.showOnlyChoosenGroup == group) {
                            vm.showOnlyChoosenGroup = group
                        }
                    }
                } else if vm.filteringGroups.count > 2 {
                    ForEach(vm.filteringGroups, id: \.self) { group in
                        GroupItem(group: group, isSelected: vm.showOnlyChoosenGroup == group) {
                            vm.showOnlyChoosenGroup = group
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 40)
        .padding(.bottom, 4)
    }
}

// Вынесенный компонент для элемента группы
struct GroupItem: View {
    let group: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Text(group)
            .foregroundColor(Color("customGray3"))
            .font(.custom("Montserrat-Medium", fixedSize: 14))
            .padding(.horizontal, 15)
            .padding(.vertical, 7)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color("blueColor") : Color.clear, lineWidth: 3)
            )
            .cornerRadius(20)
            .onTapGesture(perform: action)
    }
}

#Preview {
    @Previewable @ObservedObject var vm = ScheduleViewModel()
    @Previewable @ObservedObject var networkMonitor = NetworkMonitor()
    FilterGroupsView(vm: vm, networkMonitor: networkMonitor)
}
