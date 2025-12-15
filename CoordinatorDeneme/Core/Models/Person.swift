//
//  Person.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import Foundation

struct PersonResponse: Decodable {
    let page: Int
    let results: [Person]
    let totalPages: Int
    let totalResults: Int
}

struct Person: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let profilePath: String?
    let knownForDepartment: String?
    let popularity: Double

    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")
    }
}

struct PersonDetail: Decodable {
    let id: Int
    let name: String
    let biography: String?
    let birthday: String?
    let deathday: String?
    let placeOfBirth: String?
    let profilePath: String?
    let knownForDepartment: String?
    let popularity: Double

    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")
    }
}
