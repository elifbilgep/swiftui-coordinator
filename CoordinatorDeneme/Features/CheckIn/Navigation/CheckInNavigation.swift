//
//  CheckInNavigation.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct CheckInNavigation: View {
    @ObservedObject var coordinator: CheckInCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Text("CheckIn Root")
                .navigationTitle("Check In")
                .navigationDestination(for: CheckInRoute.self) { route in
                    switch route {
                    case .summary(let bookingId):
                        CheckInSummaryView(bookingId: bookingId)
                    }
                }
        }
    }
    
}

struct CheckInSummaryView: View {
    let bookingId: String

    var body: some View {
        Text("CheckIn Summary\nBooking: \(bookingId)")
            .multilineTextAlignment(.center)
            .padding()
    }
}
