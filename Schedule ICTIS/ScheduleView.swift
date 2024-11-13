//
//  ScheduleView.swift
//  Schedule ICTIS
//
//  Created by G412 on 13.11.2024.
//

import SwiftUI

struct ScheduleView: View {
    @State private var searchText: String = ""
    var body: some View {
        VStack {
            SearchBarView(text: $searchText)
            Spacer()
        }
        .background(.secondary.opacity(0.15))
    }
}

#Preview {
    ScheduleView()
}
