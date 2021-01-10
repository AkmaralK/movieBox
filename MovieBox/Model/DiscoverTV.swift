//
//  DiscoverTV.swift
//  MovieBox
//
//  Created by Akmaral on 1/10/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct DiscoverTV: Decodable {
    
    var page: Int
    var results: [ResultTV]
    var totalPages: Int
    var totalResults: Int
    
    private enum CodingKeys: String, CodingKey {

        case page
        case results
        case totalPages =  "total_pages"
        case totalResults = "total_results"

    }
}
  
struct ResultTV: Decodable {
    var backdropPath: String?
    var firstAirDate: String
    var genreIds: [Int]
    var id: Int
    var name: String
    var originCountry: [String]
    var originalLanguage: String
    var originalName: String
    var overview: String
    var popularity: Double
    var posterPath: String
    var voteAverage: Double
    var voteCount: Int


    
    private enum CodingKeys: String, CodingKey {
        
        case backdropPath =  "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIds =  "genre_ids"
        case id
        case name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        
    }
}
