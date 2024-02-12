//
//  SidebarView.swift
//  Drizzle
//
//  Created by Meelunae on 02/02/24.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var navigationManager: NavigationStateManager
    @EnvironmentObject var preferences: AppPreferences
    @EnvironmentObject var viewModel: PomodoroViewModel
    var body: some View {
        List(selection: $navigationManager.selectionState) {

                Section("Home") {
                    Label("Home", systemImage: "house")
                        .tag(SelectionState.home)
                }

                Section("Dashboard") {
                    Label("History", systemImage: "calendar.badge.clock")
                }

                Divider()

                Section {
                    Label("Settings", systemImage: "gear")
                        .tag(SelectionState.settings)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 150, idealWidth: 150, maxWidth: 150)
        }
}

/*
// Toggle Sidebar Function
func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}*/

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
