//
//  ContentView.swift
//  Schedule ICTIS
//
//  Created by Mironov Egor on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabBarModel = .schedule
    @State private var isTabBarHidden = false
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    var body: some View {
        ZStack (alignment: .bottom) {
            TabView(selection: $selectedTab) {
                Text("Tasks")
                    .tag(TabBarModel.tasks)
                
                MainView(vm: vm, networkMonitor: networkMonitor)
                    .tag(TabBarModel.schedule)
                    .background {
                        if !isTabBarHidden {
                            HideTabBar {
                                print("TabBar is hidden")
                                isTabBarHidden = true
                            }
                        }
                    }
                
                SettingsView(vm: vm, networkMonitor: networkMonitor)
                    .tag(TabBarModel.settings)
            }
            TabBarView(selectedTab: $selectedTab)
        }
    }
}

struct HideTabBar: UIViewRepresentable {
    var result: () -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                tabController.tabBar.isHidden = true
                result()
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: {
            $0.next
        }).first(where: { $0 is UITabBarController}) as? UITabBarController {
            return controller
        }
        return nil
    }
}

#Preview {
    @Previewable @StateObject var vm1 = ScheduleViewModel()
    @Previewable @StateObject var vm2 = NetworkMonitor()
    ContentView(vm: vm1, networkMonitor: vm2)
}
