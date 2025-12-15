//
//  Endpoint.swift
//  CoordinatorDeneme
//
//  Created by Elif Bilge Parlak on 15.12.2025.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension Endpoint {
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }
}
