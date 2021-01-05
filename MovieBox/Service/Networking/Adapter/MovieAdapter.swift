//
//  MovieAdapter.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/1/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

protocol MediaDataLoaderService {
    var apiKey: String! { get set }
    
    func loadMovieShowBySection(
        mediaType: MediaType,
        section: MoviesSectionTypes,
        page: Int,
        complitionHandler: @escaping ((MediaDataResponse)-> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    )
    
    func loadRecommendationsMovie(
        mediaType: MediaType,
        id: Int,
        page: Int,
        complitionHandler: @escaping ((MediaDataResponse)-> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    )
    
    func getDetail (
        mediaType: MediaType,
        id: Int,
        completionHandler: @escaping ((MediaData) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    )
    
    func getPersonMovies (
        mediaType: MediaType,
        id: Int,
        completionHandler: @escaping (([MediaData]) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    )
}

final class MovieDataAdapter {
    
    var apiKey: String
    
    func loadMovieShowBySection(
        mediaType: MediaType,
        section: MoviesSectionTypes,
        page: Int = 1,
        complitionHandler: @escaping ((MediaDataResponse) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)) {
            let isMovie = mediaType == .movie
            var mediaLoader: MediaDataLoaderService = isMovie ? MediaDataLoader<Movie>() : MediaDataLoader<TvShow>()
            mediaLoader.apiKey = apiKey
            mediaLoader.loadMovieShowBySection(mediaType: mediaType, section: section, page: page, complitionHandler: complitionHandler, complitionHandlerError: complitionHandlerError)
    }
    
    func loadRecommendationsMovie(
        mediaType: MediaType,
        id: Int,
        page: Int = 1,
        complitionHandler: @escaping ((MediaDataResponse)-> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        let isMovie = mediaType == .movie
        var mediaLoader: MediaDataLoaderService = isMovie ? MediaDataLoader<Movie>() : MediaDataLoader<TvShow>()
        mediaLoader.apiKey = apiKey
        mediaLoader.loadRecommendationsMovie(mediaType: mediaType, id: id, page: page, complitionHandler: complitionHandler, complitionHandlerError: complitionHandlerError)
    }
    
    func getDetails (
        mediaType: MediaType,
        id: Int,
        completionHandler: @escaping ((MediaData) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        let isMovie = mediaType == .movie
        var mediaLoader: MediaDataLoaderService = isMovie ? MediaDataLoader<Movie>() : MediaDataLoader<TvShow>()
        mediaLoader.apiKey = apiKey
        mediaLoader.getDetail(mediaType: mediaType, id: id, completionHandler: completionHandler, complitionHandlerError: complitionHandlerError)
    }
    
    func getPersonMovies (
        mediaType: MediaType,
        id: Int,
        completionHandler: @escaping (([MediaData]) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        let isMovie = mediaType == .movie
        var mediaLoader: MediaDataLoaderService = isMovie ? MediaDataLoader<Movie>() : MediaDataLoader<TvShow>()
        mediaLoader.apiKey = apiKey
        mediaLoader.getPersonMovies(mediaType: mediaType, id: id, completionHandler: completionHandler, complitionHandlerError: complitionHandlerError)
    }
    
    init (apiKey: String) {
        self.apiKey = apiKey
    }
}



