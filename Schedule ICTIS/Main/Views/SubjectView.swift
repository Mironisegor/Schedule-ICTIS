//
//  SubjectView.swift
//  Schedule ICTIS
//
//  Created by Egor Mironov on 02.04.2025.
//

import SwiftUI

struct SubjectView: View {
    let info: ClassInfo
    @ObservedObject var vm: ScheduleViewModel
    @State private var onlyOneGroup: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing) {
            if !onlyOneGroup {
                Text(info.group)
                    .font(.custom("Montserrat-Regular", fixedSize: 11))
                    .foregroundColor(Color("grayForNameGroup"))
            }
            HStack(spacing: 15) {
                VStack {
                    Text(convertTimeString(info.time)[0])
                        .font(.custom("Montserrat-Regular", fixedSize: 15))
                        .padding(.bottom, 1)
                    Text(convertTimeString(info.time)[1])
                        .font(.custom("Montserrat-Regular", fixedSize: 15))
                        .padding(.top, 1)
                }
                .frame(width: 48)
                .padding(.top, 7)
                .padding(.bottom, 7)
                .padding(.leading, 10)
                Rectangle()
                    .frame(width: 2)
                    .frame(maxHeight: UIScreen.main.bounds.height - 18)
                    .padding(.top, 7)
                    .padding(.bottom, 7)
                    .foregroundColor(getColorForClass(info.subject))
                Text(info.subject)
                    .font(.custom("Montserrat-Medium", fixedSize: 16))
                    .lineSpacing(3)
                    .padding(.top, 9)
                    .padding(.bottom, 9)
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 230)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
        }
        .onAppear {
            onlyOneGroup = (vm.showOnlyChoosenGroup != vm.filteringGroups[0])
        }
        .padding(.bottom, onlyOneGroup ? 17 : 0)
        .onChange(of: vm.showOnlyChoosenGroup) { oldValue, newValue in
            onlyOneGroup = (newValue != vm.filteringGroups[0])
        }
    }
}
