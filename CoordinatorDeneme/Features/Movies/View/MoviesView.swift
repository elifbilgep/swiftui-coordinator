//
//  MoviesView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct MoviesView: View {
    @StateObject var viewModel: MoviesViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading movies...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task {
                            await viewModel.loadMovies()
                        }
                    }
                }
                .padding()
            } else {
                List {
                    ForEach(viewModel.movies) { movie in
                        MovieRow(movie: movie)
                            .onTapGesture {
                                viewModel.movieTapped(movie.id)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    viewModel.deleteMovie(movie.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    viewModel.shareMovie(movie)
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                .tint(.blue)
                            }
                            .contextMenu {
                                Button {
                                    viewModel.showReviews(for: movie.id)
                                } label: {
                                    Label("View Reviews", systemImage: "text.bubble")
                                }

                                Button {
                                    viewModel.showCast(for: movie.id)
                                } label: {
                                    Label("View Cast", systemImage: "person.3")
                                }

                                Button {
                                    viewModel.shareMovie(movie)
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }

                                if let url = URL(string: "https://www.themoviedb.org/movie/\(movie.id)") {
                                    Button {
                                        viewModel.openMovieWebsite(url)
                                    } label: {
                                        Label("Open in Browser", systemImage: "safari")
                                    }
                                }

                                Divider()

                                Button(role: .destructive) {
                                    viewModel.deleteMovie(movie.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            await viewModel.loadMovies()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.showFilterSheet()
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        viewModel.switchToTVShows()
                    } label: {
                        Label("TV Shows", systemImage: "tv")
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

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { image in
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
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.voteAverage))
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
