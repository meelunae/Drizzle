//
//  NavigationStateManager.swift
//  Drizzle
//
//  Created by Meelunae on 12/02/24.
//

import Foundation
import Combine

enum SelectionState: Hashable, Codable {
    case home
    case settings
}

class NavigationStateManager: ObservableObject {
    @Published var selectionState: SelectionState = .home
    var data: Data? {
        get {
           try? JSONEncoder().encode(selectionState)
        }
        set {
            guard let data = newValue,
                  let selectionState = try? JSONDecoder().decode(SelectionState.self, from: data) else {
                return
            }
            // fetch updated new model data for each id
            self.selectionState = selectionState
        }
    }

    func popToRoot() {
        selectionState = .home
    }

    func goToSettings() {
        selectionState = .settings
    }

    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
}
