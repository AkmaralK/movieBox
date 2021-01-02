//
//  APIService.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/29/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SVProgressHUD

final class ApiService {
    
    static let shared = ApiService()
    
    static let movieLoader = MovieDataAdapter(apiKey: "bcd3c6393606f8cd9ab1c236f6d4e0ea")
    
    private let apiKey = "bcd3c6393606f8cd9ab1c236f6d4e0ea"
    
    func loadGenres (
        mediaType: MediaType,
        complitionHandler: @escaping (([Genre])-> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        let endpoint: Endpoint! = mediaType == MediaType.movie ? Endpoint.getMovieGenres(apiKey: apiKey, language: "en") : Endpoint.getShowGenres(apiKey: apiKey, language: "en")
        
        URLSession.shared.request(for: GenreResponse.self, endpoint) { (result) in
            switch (result) {
            case .success(let genreResponse):
                complitionHandler(genreResponse.genres)
            case .failure(let error):
                complitionHandlerError(error.errorMsg)
            }
        }
    }
    
    func loadCastPeople(
        mediaType: MediaType,
        movieID: Int,
        complitionHandler: @escaping ((PersonResponse) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)) {
            let endpoint = Endpoint.getMovieCast(apiKey: apiKey, movieID: movieID, language: "en", mediaType: mediaType)
            URLSession.shared.request(for: PersonResponse.self, endpoint) { (result) in
                switch (result) {
                case .success(let personResponse):
                    complitionHandler(personResponse)
                case .failure(let err):
                    complitionHandlerError(err.errorMsg)
                }
            }
    }
    
    func loadImages (
        movieID: Int,
        mediaType: MediaType,
        completionHandler: @escaping (([MovieImage]) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)) {
        let endpoint = Endpoint.getImages(apiKey: apiKey, id: movieID, language: "", mediaType: mediaType)
        
        URLSession.shared.request(for: MovieImages.self, endpoint) { (result) in
            switch (result) {
            case .success(let imagesResponse):
                completionHandler(imagesResponse.backdrops)
            case .failure(let err):
                complitionHandlerError(err.errorMsg)
            }
        }
    }
}
