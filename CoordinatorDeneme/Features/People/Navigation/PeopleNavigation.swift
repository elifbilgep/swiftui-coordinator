//
//  PeopleNavigation.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct PeopleNavigation: View {
    @ObservedObject var coordinator: PeopleCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            PeopleView(viewModel: createViewModel())
                .navigationTitle("People")
        }
        .sheet(item: $coordinator.sheet) { sheet in
            switch sheet {
            case .personDetail(let id):
                PersonDetailView(personId: id, coordinator: coordinator)
            }
        }
    }

    private func createViewModel() -> PeopleViewModel {
        let viewModel = PeopleViewModel()
        viewModel.coordinator = coordinator
        return viewModel
    }
}
