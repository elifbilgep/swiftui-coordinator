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
            HomeNavigation(coordinator: coordinator.homeCoordinator)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(MainTabCoordinator.Tab.home)

            MyTripsNavigation(coordinator: coordinator.myTripsCoordinator)
                .tabItem { Label("MyTrips", systemImage: "airplane") }
                .tag(MainTabCoordinator.Tab.myTrips)

            CheckInNavigation(coordinator: coordinator.checkInCoordinator)
                .tabItem { Label("CheckIn", systemImage: "checkmark.circle") }
                .tag(MainTabCoordinator.Tab.checkIn)
        }
        .onOpenURL { url in
            if let deepLink = DeepLinkParser.parse(url) {
                coordinator.handle(deepLink)
            }
        }
    }
}

#Preview {
    RootView()
}
