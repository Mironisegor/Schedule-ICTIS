//
//  ListOfGroupsView.swift
//  Schedule ICTIS
//
//  Created by G412 on 13.03.2025.
//

import SwiftUI

struct ListOfGroupsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var serchGroupsVM: SearchGroupsViewModel
    var firstFavVPK: String
    var secondFavVPK: String
    var thirdFavVPK: String
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(serchGroupsVM.groups) { item in
                if item.name.starts(with: "ВПК") {
                    VStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("customGray1"))
                            .padding(.horizontal, 10)
                        HStack {
                            Text(item.name)
                                .foregroundColor(.black)
                                .font(.custom("Montserrat-SemiBold", fixedSize: 15))
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                        .frame(width: UIScreen.main.bounds.width, height: 30)
                        .background(Color("background"))
                        .onTapGesture {
                            if firstFavVPK == "" {
                                UserDefaults.standard.set(item.name, forKey: "vpk1")
                            } else if secondFavVPK == "" {
                                UserDefaults.standard.set(item.name, forKey: "vpk2")
                            } else {
                                UserDefaults.standard.set(item.name, forKey: "vpk3")
                            }
                            vm.nameToHtml[item.name] = ""
                            vm.fetchWeekSchedule()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
