//
//  APIService.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/29/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FirebaseFirestore

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
        
        URLSession.shared.request(for: ActorsResponse.self, endpoint) { (result) in
            switch (result) {
            case .success(let personInfo):
                completionHandler(personInfo.results)
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
    
    // MARK: - Auth
    
    func login(
        email: String,
        password: String,
        completionHandler: @escaping ((AppUser) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            self.handleLogin(data, error, completionHandler: completionHandler, complitionHandlerError: complitionHandlerError)
        }
    }
    
    func register (
        email: String,
        password: String,
        completionHandler: @escaping ((AppUser) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            self.handleLogin(data, error, completionHandler: completionHandler, complitionHandlerError: complitionHandlerError)
        }
    }
    
    
    func logout (
        completionHandler: @escaping ((Bool) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        do {
            _ = try Auth.auth().signOut()
            AppStore.shared.user = nil
            completionHandler(true)
        } catch {
            complitionHandlerError(RequestError.noData.errorMsg)
        }
    }
    
    
    // MARK: - Firestore
    
    func getCurrentUser (
        userUID: String,
        completionHandler: @escaping ((AppUser) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        SVProgressHUD.show()
        
        Firestore.firestore().collection("users").document(userUID).getDocument { (document, error) in
            SVProgressHUD.dismiss()
            
            if let document = document {
                var user: AppUser = AppUser(name: "User", email: Auth.auth().currentUser!.email ?? "No email", loaded: true)
                
                if (document.exists) {
                    user = AppUser(name: document.data()!["name"] as? String ?? "", email: Auth.auth().currentUser!.email ?? "", loaded: true)
                }
                
                AppStore.shared.user = user
                completionHandler(user)
            } else if let error = error {
                complitionHandlerError(error.localizedDescription)
            } else {
                complitionHandlerError(RequestError.noData.errorMsg)
            }
        }
    }
    
    
    func updateUser (
        name: String,
        email: String,
        userUID: String,
        completionHandler: @escaping ((Bool) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        Firestore.firestore().collection("users").document(userUID).setData([
        "name": name,
        "email": email
        ], merge: true) { (error) in
            if let error = error {
                complitionHandlerError(error.localizedDescription)
            } else {
                completionHandler(true)
            }
        }
    }
    
    func addToFavorite (
        userUID: String,
        mediaData: MediaData,
        completionHandler: @escaping ((Bool) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        SVProgressHUD.show()
        
        Firestore.firestore().collection("users").document(userUID).collection("favs").document("\(mediaData.id)").setData([
            "id": mediaData.id,
            "imageUrl": mediaData.imageUrl,
            "title": mediaData.title
        ], merge: false) { error in
            SVProgressHUD.dismiss()
            
            if let error = error {
                complitionHandlerError(error.localizedDescription)
            } else {
                completionHandler(true)
            }
        }
    }
    
    
    // MARK: - UTILS
    
    fileprivate func handleLogin (
        _ authDataResult: AuthDataResult?,
        _ error: Error?,
        completionHandler: @escaping ((AppUser) -> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            complitionHandlerError(error.localizedDescription)
        } else if let _ = authDataResult {
            self.getCurrentUser(userUID: Auth.auth().currentUser?.uid ?? "", completionHandler: completionHandler, complitionHandlerError: complitionHandlerError)
            
        } else {
            complitionHandlerError(RequestError.noData.errorMsg)
        }
    }
    
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
