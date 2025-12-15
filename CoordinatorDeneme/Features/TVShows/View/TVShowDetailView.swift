//
//  TVShowDetailView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

struct TVShowDetailView: View {
    let tvShowId: Int
    @StateObject private var viewModel: TVShowDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(tvShowId: Int, coordinator: TVShowsCoordinator) {
        self.tvShowId = tvShowId
        _viewModel = StateObject(wrappedValue: TVShowDetailViewModel(tvShowId: tvShowId, coordinator: coordinator))
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
                                await viewModel.loadTVShowDetail()
                            }
                        }
                    }
                    .padding()
                } else if let tvShow = viewModel.tvShow {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: tvShow.backdropURL) { image in
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
                            Text(tvShow.name)
                                .font(.largeTitle)
                                .bold()

                            if let tagline = tvShow.tagline, !tagline.isEmpty {
                                Text(tagline)
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", tvShow.voteAverage))
                                    .font(.headline)

                                if let seasons = tvShow.numberOfSeasons {
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    Text("\(seasons) Seasons")
                                        .foregroundColor(.secondary)
                                }

                                if let episodes = tvShow.numberOfEpisodes {
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    Text("\(episodes) Episodes")
                                        .foregroundColor(.secondary)
                                }
                            }

                            if !tvShow.genres.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(tvShow.genres) { genre in
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

                            Text(tvShow.overview)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
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
            await viewModel.loadTVShowDetail()
        }
    }
}

@MainActor
final class TVShowDetailViewModel: ObservableObject {
    @Published var tvShow: TVShowDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let tvShowId: Int
    private let networkService: NetworkServiceProtocol
    weak var coordinator: TVShowsCoordinator?

    init(tvShowId: Int, coordinator: TVShowsCoordinator, networkService: NetworkServiceProtocol = NetworkService()) {
        self.tvShowId = tvShowId
        self.coordinator = coordinator
        self.networkService = networkService
    }

    func loadTVShowDetail() async {
        isLoading = true
        errorMessage = nil

        do {
            let detail: TVShowDetail = try await networkService.request(TMDbEndpoint.tvShowDetail(id: tvShowId))
            tvShow = detail
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func dismissTapped() {
        coordinator?.handle(.dismissSheet)
    }
}
