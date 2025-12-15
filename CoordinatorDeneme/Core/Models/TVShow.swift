//
//  TVShow.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import Foundation

struct TVShowResponse: Decodable {
    let page: Int
    let results: [TVShow]
    let totalPages: Int
    let totalResults: Int
}

struct TVShow: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }
}

struct TVShowDetail: Decodable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let lastAirDate: String?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let voteAverage: Double
    let voteCount: Int
    let genres: [Genre]
    let tagline: String?
    let status: String?

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }
}
