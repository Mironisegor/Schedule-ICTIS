//
//  NavigationManager.swift
//  Schedule-ICTIS
//
//  Created by Mironov Egor on 21.05.2025.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
