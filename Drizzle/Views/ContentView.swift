//
//  ContentView.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: PomodoroViewModel
    @EnvironmentObject var preferences: AppPreferences
    @SceneStorage("navigationState") var navigationStateData: Data?
    @StateObject var navigationStateManager = NavigationStateManager()

    var body: some View {
        NavigationSplitView(sidebar: {
            SidebarView()
        }, detail: {
            DetailView()
        })
        .environmentObject(navigationStateManager)
        .onAppear {
            navigationStateManager.data = navigationStateData
        }
        .onReceive(navigationStateManager.$selectionState.dropFirst()) { _ in
            navigationStateData = navigationStateManager.data
        }
    }
}

struct DetailView: View {
    @EnvironmentObject var model: PomodoroViewModel
    @EnvironmentObject var preferences: AppPreferences
    @EnvironmentObject var navigationManager: NavigationStateManager
    var body: some View {
       switch navigationManager.selectionState {
        case .home:
           PomodoroUIView()
        case .settings:
            SettingsView()
        }
   }
}

#Preview {
    ContentView()
}
