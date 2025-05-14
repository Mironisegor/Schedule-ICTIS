//
//  CustomTabBarView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: TabBarModel
    @Namespace private var animation
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 25) {
                content
            }
            .frame(height: 42)
            .animation(.smooth(duration: 0.3, extraBounce: 0), value: selectedTab)
            .padding(6)
            .background(.white)
            .mask(RoundedRectangle(cornerRadius: 35, style: .continuous))
            .shadow(color: .black.opacity(0.4), radius: 20, x: 8, y: 8)
            
            //.background(
            //    background
            //        .shadow(.drop(color: Color.black.opacity(0.08), radius: 5, x: 5, y: 5))
            //        .shadow(.drop(color: Color.black.opacity(0.08), radius: 5, x: 5, y: -5)),
            //    in: .capsule
            //)
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
                        .font(.body)
                        .fontWeight(.regular)
                }
                .frame(width: 30, height: 30)
                .foregroundStyle(selectedTab == tab ? Color.white : Color("blueColor"))
                .padding(.vertical, 7)
                .padding(.leading,  25)
                .padding(.trailing, 25)
                .background {
                    if selectedTab == tab {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color("blueColor").opacity(0.9), location: 0.0),
                                        .init(color: Color("blueColor").opacity(0.9), location: 0.5),
                                        .init(color: Color("blueColor").opacity(1.0), location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}
