//
//  Endpoints.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/28/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

enum ServiceBaseURL {
    case main, imagesHost
    
    var value: String {
        switch self {
        case .main:
            return "api.themoviedb.org"
        case .imagesHost:
            return "image.tmdb.org"
        }
    }
}

enum Endpoint {
    case getMovieGenres (apiKey: String, language: String)
    case getShowGenres (apiKey: String, language: String)
    
    // MARK; - List of Movies
    
    case getTopRated (apiKey: String, language: String, page: Int, mediaType: MediaType)
    case getUpcomingMovies (apiKey: String, language: String, page: Int, mediaType: MediaType)
    case getRecommendedMovies (apiKey: String, language: String, id: Int, page: Int, mediaType: MediaType)
    case getMovieCast (apiKey: String, movieID: Int, language: String, mediaType: MediaType)
    
    static let baseURL: String = ServiceBaseURL.main.value
    
    var path: String {
        switch self {
        case .getShowGenres(_, _):
            return "/3/genre/tv/list"
        case .getMovieGenres(_, _):
            return "/3/genre/movie/list"
        case .getTopRated(_, _, _, mediaType: let type):
            return "/3/\(type.key)/top_rated"
        case .getUpcomingMovies(_, _, _, mediaType: let type):
            return "/3/\(type.key)/upcoming"
        case .getRecommendedMovies(_, _, id: let id, _, mediaType: let type):
            return "/3/\(type.key)/\(id)/recommendations"
        case .getMovieCast(_, movieID: let id, _, mediaType: let type):
            return "/3/\(type.key)/\(id)/credits"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getMovieGenres(apiKey: let key, language: let language):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "language", value: language),
            ]
        case .getShowGenres(apiKey: let key, language: let language):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "language", value: language),
            ]
        case .getTopRated(apiKey: let key, language: let language, let page, _):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .getUpcomingMovies(apiKey: let key, language: let language, let page, _):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .getRecommendedMovies(apiKey: let key, language: let language, _, page: let page, _):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .getMovieCast(apiKey: let key, _, language: let language, _):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "language", value: language)
            ]
        }
    }
}
