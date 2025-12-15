//
//  PeopleCoordinator.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class PeopleCoordinator: ObservableObject {
    weak var parent: MainTabCoordinator?
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?

    enum Sheet: Identifiable {
        case personDetail(Int)

        var id: Int {
            switch self {
            case .personDetail(let id):
                return id
            }
        }
    }

    enum Event {
        case showPersonDetail(Int)
        case switchToMovies
        case switchToTVShows
        case dismissSheet
    }

    func handle(_ event: Event) {
        switch event {
        case .showPersonDetail(let id):
            sheet = .personDetail(id)

        case .switchToMovies:
            parent?.select(.movies)

        case .switchToTVShows:
            parent?.select(.tvShows)

        case .dismissSheet:
            sheet = nil
        }
    }
}
