//
//  FavGroupsView.swift
//  Schedule ICTIS
//
//  Created by G412 on 05.03.2025.
//

import SwiftUI

struct FavGroupsView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    var firstFavGroup = (UserDefaults.standard.string(forKey: "group") ?? "")
    var secondFavGroup = (UserDefaults.standard.string(forKey: "group2") ?? "")
    var thirdFavGroup = (UserDefaults.standard.string(forKey: "group3") ?? "")
    var body: some View {
        VStack (spacing: 0) {
            List {
                if firstFavGroup != "" {
                    HStack {
                        Text(firstFavGroup)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vm.removeFromSchedule(group: firstFavGroup)
                            UserDefaults.standard.set("", forKey: "group")
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
                if secondFavGroup != "" {
                    HStack {
                        Text(secondFavGroup)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vm.removeFromSchedule(group: secondFavGroup)
                            UserDefaults.standard.set("", forKey: "group2")
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
                if thirdFavGroup != "" {
                    HStack {
                        Text(thirdFavGroup)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vm.removeFromSchedule(group: thirdFavGroup)
                            UserDefaults.standard.set("", forKey: "group3")
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
            }
            .frame(maxHeight: 400)
            
            Spacer()
            
            HStack {
                Spacer()
                if firstFavGroup == "" || secondFavGroup == "" || thirdFavGroup == "" {
                    NavigationLink(destination: SelectingGroupView(vm: vm, networkMonitor: networkMonitor, firstFavGroup: firstFavGroup, secondFavGroup: secondFavGroup, thirdFavGroup: thirdFavGroup)) {
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
