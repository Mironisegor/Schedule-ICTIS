//
//  SheetView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 12.12.2024.
//

import SwiftUI

struct SheetChangeClassView: View {
    @Binding var isShowingSheet: Bool
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Редактирвоание пары")
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        isShowingSheet = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        isShowingSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    SheetChangeClassView(isShowingSheet: .constant(true))
}
