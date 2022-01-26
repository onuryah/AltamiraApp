//
//  ModelClass.swift
//  AltamiraApp
//
//  Created by Ceren Çapar on 25.01.2022.
//

import Foundation


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Model: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let adult: Bool
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate: String?
    let title: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
