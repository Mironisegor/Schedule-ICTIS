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
                            vm.removeFromSchedule(group: firstFavVPK)
                            UserDefaults.standard.set("", forKey: "vpk1")
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
                            vm.removeFromSchedule(group: secondFavVPK)
                            UserDefaults.standard.set("", forKey: "vpk2")
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
                            vm.removeFromSchedule(group: thirdFavVPK)
                            UserDefaults.standard.set("", forKey: "vpk3")
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
                    NavigationLink(destination: SelectingVPKView(vm: vm, networkMonitor: networkMonitor, firstFavVPK: firstFavVPK, secondFavVPK: secondFavVPK, thirdFavVPK: thirdFavVPK)) {
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
