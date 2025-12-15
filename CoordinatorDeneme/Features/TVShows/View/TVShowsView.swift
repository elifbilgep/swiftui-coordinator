//
//  TVShowsView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct TVShowsView: View {
    @StateObject var viewModel: TVShowsViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading TV shows...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task {
                            await viewModel.loadTVShows()
                        }
                    }
                }
                .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.tvShows) { tvShow in
                            TVShowRow(tvShow: tvShow)
                                .onTapGesture {
                                    viewModel.tvShowTapped(tvShow.id)
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.loadTVShows()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        viewModel.switchToMovies()
                    } label: {
                        Label("Movies", systemImage: "film")
                    }

                    Button {
                        viewModel.switchToPeople()
                    } label: {
                        Label("People", systemImage: "person.2")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct TVShowRow: View {
    let tvShow: TVShow

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: tvShow.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text(tvShow.name)
                    .font(.headline)
                    .lineLimit(2)

                Text(tvShow.overview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", tvShow.voteAverage))
                        .font(.caption)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
