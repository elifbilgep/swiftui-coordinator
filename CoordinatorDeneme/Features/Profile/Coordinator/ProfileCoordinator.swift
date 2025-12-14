//
//  ProfileCoordinator.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class ProfileCoordinator: ObservableObject {
    weak var parent: MainTabCoordinator?
    @Published var path = NavigationPath()
    
    func openCheckIn(for bookingId: String) {
        parent?.openCheckIn(bookingId: bookingId)
    }
}
