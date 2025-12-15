//
//  PeopleViewModel.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import Foundation
import Combine

@MainActor
final class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkService: NetworkServiceProtocol
    weak var coordinator: PeopleCoordinator?

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func loadPeople() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PersonResponse = try await networkService.request(TMDbEndpoint.popularPeople(page: 1))
            people = response.results
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func personTapped(_ id: Int) {
        coordinator?.handle(.showPersonDetail(id))
    }

    func switchToMovies() {
        coordinator?.handle(.switchToMovies)
    }

    func switchToTVShows() {
        coordinator?.handle(.switchToTVShows)
    }
}
