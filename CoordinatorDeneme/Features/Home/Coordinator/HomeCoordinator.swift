//
//  HomeCoordinator.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class HomeCoordinator: ObservableObject {
    weak var parent: MainTabCoordinator?
    @Published var path = NavigationPath()
    
    func goToMyTrips() {
        parent?.select(.myTrips)
    }
    
    func openCheckIn() {
        parent?.openCheckIn(bookingId: "HOME-123")
    }
}
