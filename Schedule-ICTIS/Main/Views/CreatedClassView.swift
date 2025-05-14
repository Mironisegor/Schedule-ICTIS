//
//  CreatedClassView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 23.12.2024.
//

import SwiftUI

struct CreatedClassView: View {
    @ObservedObject var _class: CoreDataClassModel
    var provider = ClassProvider.shared
    var body: some View {
        let existingCopy = try? provider.viewContext.existingObject(with: _class.objectID)
        if existingCopy != nil {
            HStack(spacing: 15) {
                VStack {
                    Text(getTimeString(_class.starttime))
                        .font(.custom("Montserrat-Regular", fixedSize: 15))
                        .padding(.bottom, 1)
                    Text(getTimeString(_class.endtime))
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
                    .foregroundColor(_class.important ? Color("redForImportant") : onlineOrNot(_class.online))
                Text(getSubjectName(_class.subject, _class.professor, _class.auditory))
                    .font(.custom("Montserrat-Medium", fixedSize: 15))
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
    }
}

#Preview {
    CreatedClassView(_class: .preview())
}
