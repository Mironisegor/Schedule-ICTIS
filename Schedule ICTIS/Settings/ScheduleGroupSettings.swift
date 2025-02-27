//
//  ScheduleGroupSettings.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 25.02.2025.
//

import SwiftUI

struct ScheduleGroupSettings: View {
    @AppStorage("group") private var favGroup = ""
    @AppStorage("vpk") private var favVPK = ""
    @ObservedObject var vm: ScheduleViewModel
    var body: some View {
        VStack {
            NavigationLink(destination: SelectingGroupView(vm: vm)) {
                HStack {
                    Text("Избранное расписание")
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Text(favGroup)
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(Color("customGray3"))
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
            NavigationLink(destination: SelectingVPKView(vm: vm)) {
                HStack {
                    Text("ВПК")
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Text(favVPK)
                        .font(.custom("Montserrat-Medium", fixedSize: 17))
                        .foregroundColor(Color("customGray3"))
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
