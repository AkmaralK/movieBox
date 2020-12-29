//
//  Movie.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/23/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let imageUrl: String
    let name: String
    let date: String
    let genres: [Genre]
    let status: String = "Выпущено"
    let initialLanguage = "Казахский"
    let budget = "230 тг"
    let sbory = "$359,900,000.00"
    
    
    static func getFakeMovies () -> [Movie] {
       return [Movie(imageUrl: "https://image.tmdb.org/t/p/w220_and_h330_face/d6bZwAUU7xEhSoSOcX4H4aNU2gj.jpg",
              name: "Messi Messi Messi",
              date: "Today",
              genres: [Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie")]
        ),
        Movie(imageUrl: "https://image.tmdb.org/t/p/w220_and_h330_face/d6bZwAUU7xEhSoSOcX4H4aNU2gj.jpg",
              name: "Messi Messi Messi",
              date: "Today",
              genres: [Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie")]),
        Movie(imageUrl: "https://image.tmdb.org/t/p/w220_and_h330_face/d6bZwAUU7xEhSoSOcX4H4aNU2gj.jpg",
              name: "Messi Messi Messi",
              date: "Today",
              genres: [Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie")]),
        Movie(imageUrl: "https://image.tmdb.org/t/p/w220_and_h330_face/d6bZwAUU7xEhSoSOcX4H4aNU2gj.jpg",
              name: "Messi Messi Messi",
              date: "Today",
              genres: [Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie"), Genre(id: 1, name: "Movie")]),
        ]
    }
}
