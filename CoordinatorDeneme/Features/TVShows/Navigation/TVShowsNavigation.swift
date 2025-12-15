//
//  TVShowsNavigation.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

struct TVShowsNavigation: View {
    @ObservedObject var coordinator: TVShowsCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            TVShowsView(viewModel: createViewModel())
                .navigationTitle("TV Shows")
        }
        .sheet(item: $coordinator.sheet) { sheet in
            switch sheet {
            case .tvShowDetail(let id):
                TVShowDetailView(tvShowId: id, coordinator: coordinator)
            }
        }
    }

    private func createViewModel() -> TVShowsViewModel {
        let viewModel = TVShowsViewModel()
        viewModel.coordinator = coordinator
        return viewModel
    }
}
