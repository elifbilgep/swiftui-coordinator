//
//  AppDeepLink.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 14.12.2025.
//

import Foundation

enum AppDeepLink: Equatable {
    case home
    case myTrips
    case checkIn(bookingId: String)
}

struct DeepLinkParser {
    static func parse(_ url: URL) -> AppDeepLink? {
        // myapp:checkin?bookingId=ABC123
        let host = url.host ?? ""
        switch host {
        case "home":
            return .home
        case "myTrips":
            return .myTrips
        case "checkIn":
            let bookingId = url.queryValue("bookingId") ?? "UNKNOWN"
            return .checkIn(bookingId: bookingId)
        default:
            return nil
        }
    }
}

private extension URL {
    func queryValue(_ name: String) -> String? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == name })?
            .value
    }
}
