//
//  PeopleView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct PeopleView: View {
    @StateObject var viewModel: PeopleViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading people...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task {
                            await viewModel.loadPeople()
                        }
                    }
                }
                .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(viewModel.people) { person in
                            PersonCard(person: person)
                                .onTapGesture {
                                    viewModel.personTapped(person.id)
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.loadPeople()
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
                        viewModel.switchToTVShows()
                    } label: {
                        Label("TV Shows", systemImage: "tv")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct PersonCard: View {
    let person: Person

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: person.profileURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 150, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(spacing: 4) {
                Text(person.name)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)

                if let department = person.knownForDepartment {
                    Text(department)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
