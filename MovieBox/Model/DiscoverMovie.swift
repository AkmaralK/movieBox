//
//  DiscoverMovie.swift
//  MovieBox
//
//  Created by Akmaral on 1/8/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct DiscoverMovie: Decodable {
    
    var page: Int
    var results: [ResultMovie] 
    var totalPages: Int
    var totalResults: Int
    
    private enum CodingKeys: String, CodingKey {

        case page
        case results
        case totalPages =  "total_pages"
        case totalResults = "total_results"

    }
}
  
struct ResultMovie: Decodable {
    var adult: Bool
    var backdropPath: String
    var genreIds: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var popularity: Double
    var posterPath: String
    var releaseDate: String
    var title: String
    var video: Bool
    var voteAverage: Double
    var voteCount: Int


    
    private enum CodingKeys: String, CodingKey {
        
        case adult
        case backdropPath =  "backdrop_path"
        case genreIds =  "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        
    }
}

