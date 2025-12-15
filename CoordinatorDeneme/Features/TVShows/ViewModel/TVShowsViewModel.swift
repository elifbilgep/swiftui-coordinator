//
//  TVShowsViewModel.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import Foundation
import Combine

@MainActor
final class TVShowsViewModel: ObservableObject {
    @Published var tvShows: [TVShow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkService: NetworkServiceProtocol
    weak var coordinator: TVShowsCoordinator?

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func loadTVShows() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: TVShowResponse = try await networkService.request(TMDbEndpoint.popularTVShows(page: 1))
            tvShows = response.results
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func tvShowTapped(_ id: Int) {
        coordinator?.handle(.showTVShowDetail(id))
    }

    func switchToMovies() {
        coordinator?.handle(.switchToMovies)
    }

    func switchToPeople() {
        coordinator?.handle(.switchToPeople)
    }
}
