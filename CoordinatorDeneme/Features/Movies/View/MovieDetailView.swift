//
//  MovieDetailView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var viewModel: MovieDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(movieId: Int, coordinator: MoviesCoordinator) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId, coordinator: coordinator))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.loadMovieDetail()
                            }
                        }
                    }
                    .padding()
                } else if let movie = viewModel.movie {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: movie.backdropURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(height: 250)
                        .clipped()

                        VStack(alignment: .leading, spacing: 12) {
                            Text(movie.title)
                                .font(.largeTitle)
                                .bold()

                            if let tagline = movie.tagline, !tagline.isEmpty {
                                Text(tagline)
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", movie.voteAverage))
                                    .font(.headline)

                                Text("•")
                                    .foregroundColor(.secondary)

                                if let runtime = movie.runtime {
                                    Text("\(runtime) min")
                                        .foregroundColor(.secondary)
                                }

                                Text("•")
                                    .foregroundColor(.secondary)

                                if let releaseDate = movie.releaseDate {
                                    Text(releaseDate)
                                        .foregroundColor(.secondary)
                                }
                            }

                            if !movie.genres.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(movie.genres) { genre in
                                            Text(genre.name)
                                                .font(.caption)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }

                            Text("Overview")
                                .font(.title2)
                                .bold()
                                .padding(.top, 8)

                            Text(movie.overview)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(50)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.dismissTapped()
                    }
                }
            }
        }
        .task {
            await viewModel.loadMovieDetail()
        }
    }
}

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movie: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let movieId: Int
    private let networkService: NetworkServiceProtocol
    weak var coordinator: MoviesCoordinator?

    init(movieId: Int, coordinator: MoviesCoordinator, networkService: NetworkServiceProtocol = NetworkService()) {
        self.movieId = movieId
        self.coordinator = coordinator
        self.networkService = networkService
    }

    func loadMovieDetail() async {
        isLoading = true
        errorMessage = nil

        do {
            let detail: MovieDetail = try await networkService.request(TMDbEndpoint.movieDetail(id: movieId))
            movie = detail
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func dismissTapped() {
        coordinator?.handle(.dismissSheet)
    }
}
