//
//  MovieItem.swift
//  MoviesInCollection
//
//  Created by George Weaver on 26.05.2023.
//

import Foundation

struct MovieItem: Decodable {
    var docs: [MovieDocs]
}

struct MovieDocs: Decodable {
    var name: String?
    var year: Int?
    var description: String?
    var rating: MovieRating?
    var poster: MoviePoster?
    var genres: [MoviewGenres]
    var countries: [MovieCountires]
}

struct MovieRating: Decodable {
    var kp: Double?
}

struct MoviePoster: Decodable {
    var previewUrl: String?
}

struct MoviewGenres: Codable {
    var name: String?
}

struct MovieCountires: Codable {
    var name: String?
}
