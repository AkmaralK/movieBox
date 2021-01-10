//
//  MovieLoader.swift
//  MovieBox
//
//  Created by Akmaral on 1/8/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

final class MovieLoader {
    
    var movies = [ResultMovie]()

    func getMovieDetails() {
        getMovies { movies in
                       DispatchQueue.main.async {
                        self.movies = movies
                           NotificationCenter.default.post(
                           name: NSNotification.Name(rawValue: "movieNotification"),
                           object: movies,
                           userInfo: nil)
                    }
            }
    }
    
    func getMovies (completion: @escaping ([ResultMovie]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=bcd3c6393606f8cd9ab1c236f6d4e0ea&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let discoverMovie = try jsonDecoder.decode(DiscoverMovie.self, from: data)
                            completion(discoverMovie.results)
                        } catch {
                            print(error)
                        }
                    }
            }
            dataTask.resume()
     }
    
}
