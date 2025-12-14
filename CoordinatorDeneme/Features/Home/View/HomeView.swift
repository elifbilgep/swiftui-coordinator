//
//  HomeVşew.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct HomeView: View {
    let coordinator: HomeCoordinator
    
    var body: some View {
        VStack {
            Button("Go to MyTrips tab") {
                coordinator.goToMyTrips()
            }
            
            Button("Open CheckIn (booking HOME-123)") {
                coordinator.openCheckIn()
            }
        }
        .padding()
    }
}

