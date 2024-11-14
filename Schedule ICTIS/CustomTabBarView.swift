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
    @Binding var selectedTab: TabModel
//    @NameSpace private var animation
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                content
            }
            .animation(.smooth(duration: 0.3, extraBounce: 0), value: selectedTab)
            .padding(6)
            .background(.clear)
            .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
            
    //        .background(
    //            background
    //                .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
    //                .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: -5)),
    //            in: .capsule
    //        )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var content: some View {
        ForEach(TabModel.allCases, id: \.rawValue) { tab in
            Button {
                selectedTab = tab
            } label: {
                VStack {
                    Image(systemName: tab.rawValue)
                        .font(.title)
                        .frame(width: 80, height: 35)
                }
                .foregroundStyle(selectedTab == tab ? isActiveForeground : Color("blueColor"))
                .padding(.vertical, 7)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background {
                    if selectedTab == tab {
                        Capsule()
                            .fill(isActiveBackground)
//                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}
