//
//  MoviesViewModel.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import Combine
import Foundation

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkService: NetworkServiceProtocol
    weak var coordinator: MoviesCoordinator?

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func loadMovies() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: MovieResponse = try await networkService.request(TMDbEndpoint.popularMovies(page: 1))
            movies = response.results
            coordinator?.handle(.showToast("Movies loaded successfully", .success))
        } catch {
            errorMessage = error.localizedDescription
            coordinator?.handle(.showError(error.localizedDescription))
        }

        isLoading = false
    }

    // MARK: - Navigation Events

    func movieTapped(_ id: Int) {
        coordinator?.handle(.showMovieDetail(id))
    }

    func switchToTVShows() {
        coordinator?.handle(.switchToTVShows)
    }

    func switchToPeople() {
        coordinator?.handle(.switchToPeople)
    }

    // MARK: - Sheet Events

    func showFilterSheet() {
        coordinator?.handle(.showFilterSheet)
    }

    func shareMovie(_ movie: Movie) {
        coordinator?.handle(.showShareSheet(movie))
    }

    // MARK: - Push Navigation Events

    func showReviews(for movieId: Int) {
        coordinator?.handle(.push(.reviews(movieId: movieId)))
    }

    func showCast(for movieId: Int) {
        coordinator?.handle(.push(.cast(movieId: movieId)))
    }

    // MARK: - Alert Events

    func deleteMovie(_ id: Int) {
        coordinator?.handle(.showAlert(.confirmation(
            title: "Delete Movie",
            message: "Are you sure you want to delete this movie from your favorites?",
            action: { [weak self] in
                self?.performDelete(id)
            }
        )))
    }

    private func performDelete(_ id: Int) {
        movies.removeAll { $0.id == id }
        coordinator?.handle(.showToast("Movie deleted", .info))
    }

    // MARK: - External Navigation

    func openMovieWebsite(_ url: URL) {
        coordinator?.handle(.openURL(url))
    }
}
