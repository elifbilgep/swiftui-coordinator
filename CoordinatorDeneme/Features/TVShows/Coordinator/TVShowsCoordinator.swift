//
//  TVShowsCoordinator.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class TVShowsCoordinator: ObservableObject {
    weak var parent: MainTabCoordinator?
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?

    enum Sheet: Identifiable {
        case tvShowDetail(Int)

        var id: Int {
            switch self {
            case .tvShowDetail(let id):
                return id
            }
        }
    }

    enum Event {
        case showTVShowDetail(Int)
        case switchToMovies
        case switchToPeople
        case dismissSheet
    }

    func handle(_ event: Event) {
        switch event {
        case .showTVShowDetail(let id):
            sheet = .tvShowDetail(id)

        case .switchToMovies:
            parent?.select(.movies)

        case .switchToPeople:
            parent?.select(.people)

        case .dismissSheet:
            sheet = nil
        }
    }
}
