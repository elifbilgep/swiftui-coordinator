//
//  MainTabCoordinator.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class MainTabCoordinator: ObservableObject {

    enum Tab: Hashable { case movies, tvShows, people }

    @Published var selectedTab: Tab = .movies

    let moviesCoordinator: MoviesCoordinator
    let tvShowsCoordinator: TVShowsCoordinator
    let peopleCoordinator: PeopleCoordinator

    init() {
        moviesCoordinator = MoviesCoordinator()
        tvShowsCoordinator = TVShowsCoordinator()
        peopleCoordinator = PeopleCoordinator()

        moviesCoordinator.parent = self
        tvShowsCoordinator.parent = self
        peopleCoordinator.parent = self
    }

    func select(_ tab: Tab) {
        selectedTab = tab
    }
}
