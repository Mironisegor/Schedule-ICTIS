//
//  FilterGroupsView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 21.03.2025.
//

import SwiftUI

struct FilterGroupsView: View {
    @ObservedObject var vm: ScheduleViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(vm.filteringGroups, id: \.self) { group in
                    VStack {
                        Text(group)
                            .foregroundColor(Color("customGray3"))
                            .font(.custom("Montserrat-Medium", fixedSize: 14))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 7)
                    }
                    .background(Color.white)
                    .overlay (
                        Group {
                            if vm.showOnlyChoosenGroup == group {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("blueColor"), lineWidth: 3)
                            }
                        }
                    )
                    .cornerRadius(20)
                    .onTapGesture {
                        vm.showOnlyChoosenGroup = group
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 40)
        .onAppear {
            vm.updateFilteringGroups()
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    @Previewable @ObservedObject var vm = ScheduleViewModel()
    FilterGroupsView(vm: vm)
}
