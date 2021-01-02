//
//  MoviesSectionData.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/31/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct DataSection<T> {
    var data: [T]
    var page: Int = 1
    var isLoading = false
    var isFinished = false
    
    
    mutating func next (totalPages: Int) {
        if (totalPages > page) {
            page += 1
            isFinished = false
        } else {
            isFinished = true
        }
    }
}

enum MoviesSectionTypes: CaseIterable {
    case topRated, upcoming, topRatedTv
    
    var title: String {
        switch self {
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        case .topRatedTv:
            return "Top Rated TV"
        }
    }
    
    var mediaType: MediaType {
        switch self {
        case .topRatedTv:
            return .tv
        case .upcoming, .topRated:
            return .movie
        }
    }
    
    var isMovie: Bool {
        return mediaType == .movie
    }
    
    func getEndpoint (apiKey: String, language: String, page: Int) -> Endpoint {
        switch self {
        case .topRated:
            return Endpoint.getTopRated(apiKey: apiKey, language: language, page: page, mediaType: mediaType)
        case .upcoming:
            return Endpoint.getUpcomingMovies(apiKey: apiKey, language: "en", page: page, mediaType: mediaType)
        case .topRatedTv:
            return Endpoint.getTopRated(apiKey: apiKey, language: "en", page: page, mediaType: mediaType)
        }
    }
}
