//
//  FavGroupsView.swift
//  Schedule ICTIS
//
//  Created by G412 on 05.03.2025.
//

import SwiftUI

struct FavVPKView: View {
    @ObservedObject var vm: ScheduleViewModel
    var firstFavVPK = (UserDefaults.standard.string(forKey: "vpk1") ?? "")
    var secondFavVPK = (UserDefaults.standard.string(forKey: "vpk2") ?? "")
    var thirdFavVPK = (UserDefaults.standard.string(forKey: "vpk3") ?? "")
    var body: some View {
        VStack (spacing: 0) {
            List {
                if firstFavVPK != "" {
                    HStack {
                        Text(firstFavVPK)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            UserDefaults.standard.set("", forKey: "vpk1")
                            vm.updateArrayOfGroups()
                            vm.fetchWeekSchedule()
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
                if secondFavVPK != "" {
                    HStack {
                        Text(secondFavVPK)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            UserDefaults.standard.set("", forKey: "vpk2")
                            vm.updateArrayOfGroups()
                            vm.fetchWeekSchedule()
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
                if thirdFavVPK != "" {
                    HStack {
                        Text(thirdFavVPK)
                            .font(.custom("Montserrat-Medium", fixedSize: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            UserDefaults.standard.set("", forKey: "vpk3")
                            vm.updateArrayOfGroups()
                            vm.fetchWeekSchedule()
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
                if firstFavVPK == "" || secondFavVPK == "" || thirdFavVPK == "" {
                    NavigationLink(destination: SelectingVPKView(vm: vm, firstFavVPK: firstFavVPK, secondFavVPK: secondFavVPK, thirdFavVPK: thirdFavVPK)) {
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
            .padding(.bottom, 50)
        }
        .background(Color("background"))
    }
}

#Preview {
    @Previewable @StateObject var vm = ScheduleViewModel()
    FavVPKView(vm: vm)
}
