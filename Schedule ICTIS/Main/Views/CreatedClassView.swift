//
//  CreatedClassView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 23.12.2024.
//

import SwiftUI

struct CreatedClassView: View {
    @ObservedObject var _class: ClassModel
    var provider = ClassProvider.shared
    var body: some View {
        let existingCopy = try? provider.viewContext.existingObject(with: _class.objectID)
        if existingCopy != nil {
            HStack(spacing: 10) {
                VStack {
                    Text(getTimeString(_class.starttime))
                        .font(.custom("Montserrat-Regular", size: 15))
                    Text(getTimeString(_class.endtime))
                        .font(.custom("Montserrat-Regular", size: 15))
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
                    .foregroundColor(_class.important ? Color("redForImportant") : onlineOrNot(_class.online))
                Text(getSubjectName(_class.subject, _class.professor, _class.auditory))
                    .font(.custom("Montserrat-Medium", size: 15))
                    .padding(.top, 7)
                    .padding(.bottom, 7)
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 230)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
        }
    }
}

#Preview {
    CreatedClassView(_class: .preview())
}
