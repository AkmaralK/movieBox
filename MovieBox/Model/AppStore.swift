//
//  AppStore.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/1/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation


enum MediaType: CaseIterable {
    case movie, tv
    
    var key: String {
        switch self {
        case .movie:
            return "movie"
        default:
            return "tv"
        }
    }
}

final class AppStore {
    static let shared = AppStore()
    
    var user: AppUser?
    
    var genres: [Genre] = []
    
    func getGenre (from id: Int) -> Genre {
       if let genId = genres.first(where: { (genre) -> Bool in
            genre.id == id
       }) {
        return genId
       }
        return Genre(id: 0, name: "")
    }
}
