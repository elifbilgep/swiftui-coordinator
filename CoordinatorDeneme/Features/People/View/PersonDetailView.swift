//
//  PersonDetailView.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

struct PersonDetailView: View {
    let personId: Int
    @StateObject private var viewModel: PersonDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(personId: Int, coordinator: PeopleCoordinator) {
        self.personId = personId
        _viewModel = StateObject(wrappedValue: PersonDetailViewModel(personId: personId, coordinator: coordinator))
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
                                await viewModel.loadPersonDetail()
                            }
                        }
                    }
                    .padding()
                } else if let person = viewModel.person {
                    VStack(spacing: 16) {
                        AsyncImage(url: person.profileURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 200, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 12) {
                            Text(person.name)
                                .font(.largeTitle)
                                .bold()

                            if let department = person.knownForDepartment {
                                HStack {
                                    Image(systemName: "briefcase")
                                        .foregroundColor(.blue)
                                    Text(department)
                                        .font(.headline)
                                }
                            }

                            if let birthday = person.birthday {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                    Text("Born: \(birthday)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    if let deathday = person.deathday {
                                        Text("- \(deathday)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            if let placeOfBirth = person.placeOfBirth {
                                HStack {
                                    Image(systemName: "mappin.circle")
                                        .foregroundColor(.blue)
                                    Text(placeOfBirth)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }

                            if let biography = person.biography, !biography.isEmpty {
                                Text("Biography")
                                    .font(.title2)
                                    .bold()
                                    .padding(.top, 8)

                                Text(biography)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
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
            await viewModel.loadPersonDetail()
        }
    }
}

@MainActor
final class PersonDetailViewModel: ObservableObject {
    @Published var person: PersonDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let personId: Int
    private let networkService: NetworkServiceProtocol
    weak var coordinator: PeopleCoordinator?

    init(personId: Int, coordinator: PeopleCoordinator, networkService: NetworkServiceProtocol = NetworkService()) {
        self.personId = personId
        self.coordinator = coordinator
        self.networkService = networkService
    }

    func loadPersonDetail() async {
        isLoading = true
        errorMessage = nil

        do {
            let detail: PersonDetail = try await networkService.request(TMDbEndpoint.personDetail(id: personId))
            person = detail
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func dismissTapped() {
        coordinator?.handle(.dismissSheet)
    }
}
