//
//  CustomTabBarView.swift
//  Schedule ICTIS
//
//  Created by Egor Mironov on 13.11.2024.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: TabBarModel
//    @NameSpace private var animation
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 15) {
                content
            }
            .animation(.smooth(duration: 0.3, extraBounce: 0), value: selectedTab)
            .padding(6)
            .background(.white)
            .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 8, x: 4, y: 4)
            
    //        .background(
    //            background
    //                .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
    //                .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: -5)),
    //            in: .capsule
    //        )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)  // Фиксаци таб-бара, при появлении клавиатуры
    }
    
    var content: some View {
        ForEach(TabBarModel.allCases, id: \.rawValue) { tab in
            Button {
                selectedTab = tab
            } label: {
                VStack (alignment: .center) {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                }
                .frame(width: 70, height: 28)
                .foregroundStyle(selectedTab == tab ? Color.white : Color("blueColor"))
                .padding(.vertical, 7)
                .padding(.leading, 13)
                .padding(.trailing, 13)
                .background {
                    if selectedTab == tab {
                        Capsule()
                            .fill(Color("blueColor"))
//                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}
