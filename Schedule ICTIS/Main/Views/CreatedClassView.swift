//
//  CreatedClassView.swift
//  Schedule ICTIS
//
//  Created by G412 on 23.12.2024.
//

import SwiftUI

struct CreatedClassView: View {
    let _class: ClassModel
    var body: some View {
        HStack(spacing: 10) {
            VStack {
                Text(getTimeString(_class.starttime))
                    .font(.system(size: 15, weight: .regular))
                Text(getTimeString(_class.endtime))
                    .font(.system(size: 15, weight: .regular))
            }
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
                .font(.system(size: 18, weight: .regular))
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

#Preview {
    CreatedClassView(_class: .preview())
}
