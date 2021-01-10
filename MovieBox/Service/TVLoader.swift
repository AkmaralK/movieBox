//
//  TVLoader.swift
//  MovieBox
//
//  Created by Akmaral on 1/10/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

final class TVLoader {
    
    var tvShows = [ResultTV]()

    func getTVDetails() {
        getTVShows { tvShows in
                       DispatchQueue.main.async {
                        self.tvShows = tvShows
                           NotificationCenter.default.post(
                           name: NSNotification.Name(rawValue: "movieNotification"),
                           object: tvShows,
                           userInfo: nil)
                    }
            }
    }
    
    func getTVShows (completion: @escaping ([ResultTV]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/discover/tv?api_key=bcd3c6393606f8cd9ab1c236f6d4e0ea&language=en-US&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&include_null_first_air_dates=false"
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let discoverTV = try jsonDecoder.decode(DiscoverTV.self, from: data)
                            completion(discoverTV.results)
                        } catch {
                            print(error)
                        }
                    }
            }
            dataTask.resume()
     }
    
}

