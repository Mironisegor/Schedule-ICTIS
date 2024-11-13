//
//  CustomTabBarView.swift
//  Schedule ICTIS
//
//  Created by G412 on 13.11.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    var isActiveForeground: Color = .white
    var isActiveBackground: Color = Color("blueColor")
    @Binding var isActiveTabBar: TabModel
//    @NameSpace private var animation
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                Button {
                    isActiveTabBar = tab
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: tab.rawValue)
                            .font(.title)
                            .frame(width: 80, height: 35)
                    }
                    .foregroundStyle(isActiveTabBar == tab ? isActiveForeground : Color("blueColor"))
                    .padding(.vertical, 7)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .background {
                        if isActiveTabBar == tab {
                            Capsule()
                                .fill(isActiveBackground)
//                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 5)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: isActiveTabBar)
//        .background(
//            background
//                .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
//                .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: -5)),
//            in: .capsule
//        )
    }
}

#Preview {
    ContentView()
}
