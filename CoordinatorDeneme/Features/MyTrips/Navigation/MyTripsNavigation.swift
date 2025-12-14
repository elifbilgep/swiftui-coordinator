//
//  MyTripsNavigation.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct MyTripsNavigation: View {
    @ObservedObject var coordinator: MyTripsCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MyTripsView(coordinator: coordinator)
                .navigationTitle("My Trips")
        }
    }
}

