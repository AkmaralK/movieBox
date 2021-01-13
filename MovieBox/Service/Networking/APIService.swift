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
    
    func getPersonDetails (
        personID: Int,
        completionHandler: @escaping ((Person) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)) {
        
        let endpoint = Endpoint.getPersonDetails(apiKey: apiKey, id: personID, language: "en")
        
        URLSession.shared.request(for: Person.self, endpoint) { (result) in
            switch (result) {
            case .success(let personInfo):
                completionHandler(personInfo)
            case .failure(let err):
                complitionHandlerError(err.errorMsg)
            }
        }
    }
    
    func getPersonPopular (
        completionHandler: @escaping (([Person]) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)) {
        
        let endpoint = Endpoint.getPersonPopular(apiKey: apiKey, language: "en", page: 1)
        
        URLSession.shared.request(for: PersonResponse.self, endpoint) { (result) in
            switch (result) {
            case .success(let personInfo):
                completionHandler(personInfo.cast)
            case .failure(let err):
                complitionHandlerError(err.errorMsg)
            }
        }
    }
    
    func searchMedia (
        query: String,
        completionHandler: @escaping (([Any]) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        let endpoint = Endpoint.searchMedia(apiKey: apiKey, language: "en", query: query)
        SVProgressHUD.show()
        
        URLSession.shared.requestJSON(endpoint) { (result) in
            switch (result) {
            case .success(let data):
                self.parseSearchJSON(json: data) { (results) in
                    completionHandler(results)
                    SVProgressHUD.dismiss()
                }
            case .failure(let err):
                complitionHandlerError(err.errorMsg)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    // MARK: - UTILS
    
    fileprivate func parseSearchJSON (
        json: [String: Any],
        completion: (([Any]) -> Void)
    ) {
        var searchResults: [Any] = []
        
        if let results = json["results"] as? [[String: Any]] {
            results.forEach { (result) in
                if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) {
                    let mediaType = result["media_type"] as? String ?? ""
                    let decoder = JSONDecoder()
                    
                    if (mediaType == MediaType.tv.key) {
                        if let jsonResponse = try? decoder.decode(TvShow.self, from: jsonData) {
                            searchResults.append(jsonResponse)
                            completion(searchResults)
                        }
                    } else if mediaType == MediaType.movie.key {
                        if let jsonResponse = try? decoder.decode(Movie.self, from: jsonData) {
                            searchResults.append(jsonResponse)
                            completion(searchResults)
                        }
                    } else {
                        if let jsonResponse = try? decoder.decode(Person.self, from: jsonData) {
                            searchResults.append(jsonResponse)
                            completion(searchResults)
                        }
                    }
                }
            }
        }
    }
}
