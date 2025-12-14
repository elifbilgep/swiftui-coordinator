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
    
    enum Tab: Hashable { case home, myTrips, checkIn, profile}
    
    @Published var selectedTab: Tab = .home
    
    let homeCoordinator: HomeCoordinator
    let myTripsCoordinator: MyTripsCoordinator
    let checkInCoordinator: CheckInCoordinator
    let profileCoordinator: ProfileCoordinator
    
    init() {
        // parent referansı, tablar arası yönlendirme için işimize yarıyor
        homeCoordinator = HomeCoordinator()
        myTripsCoordinator = MyTripsCoordinator()
        checkInCoordinator = CheckInCoordinator()
        profileCoordinator = ProfileCoordinator()
        
        homeCoordinator.parent = self
        myTripsCoordinator.parent = self
        checkInCoordinator.parent = self
        profileCoordinator.parent = self
    }
    
    func select(_ tab: Tab) {
        selectedTab = tab
    }
    
    func openCheckIn(bookingId: String) {
        selectedTab = .checkIn
        checkInCoordinator.start(bookingId: bookingId)
    }

    func handle(_ deepLink: AppDeepLink) {
        switch deepLink {
        case .home:
            select(.home)
        case .myTrips:
            select(.myTrips)
        case .checkIn(let bookingId):
            openCheckIn(bookingId: bookingId)
        }
    }
}
