//
//  OffsetKey.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 18.11.2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
