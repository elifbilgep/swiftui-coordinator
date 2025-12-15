//
//  RootView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = MainTabCoordinator()

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            MoviesNavigation(coordinator: coordinator.moviesCoordinator)
                .tabItem { Label("Movies", systemImage: "film") }
                .tag(MainTabCoordinator.Tab.movies)

            TVShowsNavigation(coordinator: coordinator.tvShowsCoordinator)
                .tabItem { Label("TV Shows", systemImage: "tv") }
                .tag(MainTabCoordinator.Tab.tvShows)

            PeopleNavigation(coordinator: coordinator.peopleCoordinator)
                .tabItem { Label("People", systemImage: "person.2") }
                .tag(MainTabCoordinator.Tab.people)
        }
    }
}

#Preview {
    RootView()
}
