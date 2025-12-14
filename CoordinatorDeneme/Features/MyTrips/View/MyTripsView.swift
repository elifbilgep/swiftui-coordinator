//
//  MyTripsView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct MyTripsView: View {
    let coordinator: MyTripsCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Button("Open CheckIn for TRIPS-456") {
                coordinator.openCheckIn(for: "TRIPS-456")
            }
        }
        .padding()
    }
}
   
