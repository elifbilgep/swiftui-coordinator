//
//  MoviesNavigation.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI

struct MoviesNavigation: View {
    @ObservedObject var coordinator: MoviesCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MoviesView(viewModel: createViewModel())
                .navigationTitle("Movies")
                .navigationDestination(for: MoviesCoordinator.Destination.self) { destination in
                    switch destination {
                    case .reviews(let movieId):
                        Text("Reviews for movie \(movieId)")
                    case .cast(let movieId):
                        Text("Cast for movie \(movieId)")
                    }
                }
        }
        .sheet(item: $coordinator.sheet) { sheet in
            switch sheet {
            case .movieDetail(let id):
                MovieDetailView(movieId: id, coordinator: coordinator)
            case .filter:
                Text("Filter Sheet")
            case .share(let movie):
                Text("Share: \(movie.title)")
            }
        }
        .alert(item: $coordinator.alert) { alertType in
            switch alertType {
            case .error(let message):
                return Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            case .confirmation(let title, let message, let action):
                return Alert(
                    title: Text(title),
                    message: Text(message),
                    primaryButton: .destructive(Text("Confirm")) {
                        action()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .overlay(alignment: .top) {
            if let toast = coordinator.toast {
                ToastView(message: toast.message, type: toast.type)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: coordinator.toast)
                    .padding(.top, 50)
            }
        }
    }

    private func createViewModel() -> MoviesViewModel {
        let viewModel = MoviesViewModel()
        viewModel.coordinator = coordinator
        return viewModel
    }
}

struct ToastView: View {
    let message: String
    let type: MoviesCoordinator.ToastMessage.ToastType

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(.white)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }

    private var iconName: String {
        switch type {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }

    private var backgroundColor: Color {
        switch type {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        }
    }
}
