//
//  ScheduleGroupSettings.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 25.02.2025.
//

import SwiftUI

struct ScheduleGroupSettings: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    var body: some View {
        VStack {
            NavigationLink(destination: FavGroupsView(vm: vm, networkMonitor: networkMonitor)) {
                HStack {
                    Text("Избранное расписание")
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Image("arrowRight")
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 3)
            }
            Rectangle()
                .foregroundColor(Color("customGray1"))
                .frame(height: 1)
                .padding(.horizontal)
            NavigationLink(destination: FavVPKView(vm: vm, networkMonitor: networkMonitor)) {
                HStack {
                    Text("Избранное ВПК")
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Image("arrowRight")
                }
                .padding(.horizontal)
                .padding(.top, 3)
                .padding(.bottom, 12)
            }
        }
        .background(Color.white)
        .cornerRadius(20)
    }
}
