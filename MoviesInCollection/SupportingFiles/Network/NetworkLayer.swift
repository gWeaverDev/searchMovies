//
//  NetworkLayer.swift
//  MoviesInCollection
//
//  Created by George Weaver on 26.05.2023.
//

import Foundation

enum ApiType {
    case getMovies
}

extension ApiType {
    
    var baseURL: URL {
        return URL(string: "https://api.kinopoisk.dev/v1.3/movie?sortField=rating.kp&page=1&limit=10&type=movie")!
    }
    
    var headers: [String: String] {
        switch self {
        case .getMovies:
            return ["X-API-KEY": "GAHHQ5E-Z9C4ZXP-NQ65A5S-61Z3924"]
        }
    }
    
    var request: URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        switch self {
        case .getMovies:
            request.httpMethod = "GET"
        }
        return request
    }
}
