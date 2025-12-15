//
//  MoviesCoordinator.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class MoviesCoordinator: ObservableObject {
    weak var parent: MainTabCoordinator?
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var alert: AlertType?
    @Published var toast: ToastMessage?

    enum Sheet: Identifiable {
        case movieDetail(Int)
        case filter
        case share(Movie)

        var id: String {
            switch self {
            case .movieDetail(let id):
                return "movie_\(id)"
            case .filter:
                return "filter"
            case .share(let movie):
                return "share_\(movie.id)"
            }
        }
    }

    enum AlertType: Identifiable {
        case error(String)
        case confirmation(title: String, message: String, action: () -> Void)

        var id: String {
            switch self {
            case .error:
                return "error"
            case .confirmation:
                return "confirmation"
            }
        }
    }

    struct ToastMessage: Identifiable, Equatable {
        let id = UUID()
        let message: String
        let type: ToastType

        enum ToastType {
            case success
            case error
            case info
        }
    }

    // Push navigation için destinations
    enum Destination: Hashable {
        case reviews(movieId: Int)
        case cast(movieId: Int)
    }

    // ViewModel'den gelen eventleri handle ediyoruz
    enum Event {
        // Sheet presentations
        case showMovieDetail(Int)
        case showFilterSheet
        case showShareSheet(Movie)
        case dismissSheet

        // Alerts
        case showAlert(AlertType)
        case showError(String)

        // Toast messages
        case showToast(String, ToastMessage.ToastType)

        // Push navigation
        case push(Destination)
        case pop
        case popToRoot

        // Tab switching
        case switchToTVShows
        case switchToPeople

        // External
        case openURL(URL)
    }

    func handle(_ event: Event) {
        switch event {
        // Sheet presentations
        case .showMovieDetail(let id):
            sheet = .movieDetail(id)

        case .showFilterSheet:
            sheet = .filter

        case .showShareSheet(let movie):
            sheet = .share(movie)

        case .dismissSheet:
            sheet = nil

        // Alerts
        case .showAlert(let alertType):
            alert = alertType

        case .showError(let message):
            alert = .error(message)

        // Toast messages
        case .showToast(let message, let type):
            toast = ToastMessage(message: message, type: type)
            // Auto dismiss after 3 seconds
            Task {
                try? await Task.sleep(for: .seconds(3))
                toast = nil
            }

        // Push navigation
        case .push(let destination):
            path.append(destination)

        case .pop:
            if !path.isEmpty {
                path.removeLast()
            }

        case .popToRoot:
            path.removeLast(path.count)

        // Tab switching
        case .switchToTVShows:
            parent?.select(.tvShows)

        case .switchToPeople:
            parent?.select(.people)

        // External
        case .openURL(let url):
            UIApplication.shared.open(url)
        }
    }
}
