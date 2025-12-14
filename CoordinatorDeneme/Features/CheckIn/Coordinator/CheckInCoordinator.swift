//
//  CheckInCoordinator.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

enum CheckInRoute: Hashable {
    case summary(String)
}

@MainActor
final class CheckInCoordinator: ObservableObject {
    weak var parent: MainTabCoordinator?
    @Published var path = NavigationPath()
    
    func start(bookingId: String) {
        path = NavigationPath() // deeplink geldiğinde stack temiz
        path.append(CheckInRoute.summary(bookingId))
    }
}
