//
//  FavGroupsView.swift
//  Schedule ICTIS
//
//  Created by G412 on 05.03.2025.
//

import SwiftUI

struct FavGroupsView: View {
    @ObservedObject var vm: ScheduleViewModel
    var firstFavGroup = (UserDefaults.standard.string(forKey: "group") ?? "")
    var secondFavGroup = (UserDefaults.standard.string(forKey: "group2") ?? "")
    var thirdFavGroup = (UserDefaults.standard.string(forKey: "group3") ?? "")
    var body: some View {
        VStack {
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
                            UserDefaults.standard.set("", forKey: "group")
                            vm.updateArrayOfGroups()
                            vm.fetchWeekSchedule()
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
                            UserDefaults.standard.set("", forKey: "group2")
                            vm.updateArrayOfGroups()
                            vm.fetchWeekSchedule()
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
                            UserDefaults.standard.set("", forKey: "group3")
                            vm.updateArrayOfGroups()
                            vm.fetchWeekSchedule()
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
            }
            if firstFavGroup == "" || secondFavGroup == "" || thirdFavGroup == "" {
                NavigationLink(destination: SelectingGroupView(vm: vm, firstFavGroup: firstFavGroup, secondFavGroup: secondFavGroup, thirdFavGroup: thirdFavGroup)) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .padding(EdgeInsets(top: 15, leading: 130, bottom: 15, trailing: 130))
                        }
                        .padding(.horizontal)
                        .background(Color("blueColor"))
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
            }
        }
        .background(Color("background"))
    }
}

#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    FavGroupsView(vm: vm)
}
