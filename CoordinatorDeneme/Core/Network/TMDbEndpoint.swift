//
//  TMDbEndpoint.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import Foundation

enum TMDbEndpoint: Endpoint {
    case popularMovies(page: Int)
    case movieDetail(id: Int)
    case popularTVShows(page: Int)
    case tvShowDetail(id: Int)
    case popularPeople(page: Int)
    case personDetail(id: Int)

    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .popularTVShows:
            return "/tv/popular"
        case .tvShowDetail(let id):
            return "/tv/\(id)"
        case .popularPeople:
            return "/person/popular"
        case .personDetail(let id):
            return "/person/\(id)"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = []

        items.append(URLQueryItem(name: "api_key", value: AppConfiguration.tmdbAPIKey))
        items.append(URLQueryItem(name: "language", value: "en-US"))

        switch self {
        case .popularMovies(let page),
             .popularTVShows(let page),
             .popularPeople(let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        default:
            break
        }

        return items
    }
}
