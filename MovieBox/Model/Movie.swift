//
//  Movie.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/23/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

enum ImageSize {
    case poster, wallpaper
    
    var path: String {
        switch self {
        case .poster:
            return "t/p/w220_and_h330_face"
        case .wallpaper:
            return "t/p/w1920_and_h800_multi_faces"
        }
    }
    
    func getURL (imagePath: String) -> String {
        return "https://\(ServiceBaseURL.imagesHost.value)/\(path)/\(imagePath)"
    }
}

protocol MediaData: Decodable {
    var id: Int { get set }
    var imageUrl: String? { get set }
    var bigImageUrl: String? { get set }
    var title: String { get set }
    var date: String? { get set }
    var genres: [Genre] { get set }
    var status: String? { get set }
    var initialLanguage: String? { get set }
    var overview: String { get set }
    var voteAverage: Double { get set }
}

extension MediaData {
    func getMediaType () -> MediaType {
        if (self is Movie) {
            return .movie
        } else {
            return .tv
        }
    }
}


struct Movie: MediaData, Decodable {
    var id: Int
    var imageUrl: String?
    var bigImageUrl: String?
    var title: String
    var date: String?
    var genres: [Genre] = []
    var status: String? = "Выпущено"
    var initialLanguage: String? = "Казахский"
    var sbory: String? = "$359,900,000.00"
    var overview: String
    var voteAverage: Double
    var originalCountries: [Country]?
    
    enum CodingKeys: CodingKey {
        case backdrop_path, genre_ids, id, original_language, poster_path, release_date, revenue, status, title, overview, vote_average, production_countries
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.title = (try? values.decode(String.self, forKey: .title)) ?? ""
        self.date = try? values.decode(String.self, forKey: .release_date)
        self.sbory = try? values.decode(String.self, forKey: .revenue)
        self.initialLanguage = try? values.decode(String.self, forKey: .original_language)
        self.overview = (try? values.decode(String.self, forKey: .overview)) ?? ""
        self.imageUrl = ImageSize.poster.getURL(imagePath: (try? values.decode(String.self, forKey: .poster_path)) ?? "")
        self.bigImageUrl = ImageSize.wallpaper.getURL(imagePath: (try? values.decode(String.self, forKey: .backdrop_path)) ?? "")
        self.genres = ((try? values.decode([Int].self, forKey: .genre_ids)) ?? []).map {
            AppStore.shared.getGenre(from: $0)
        }
        self.voteAverage = try values.decode(Double.self, forKey: .vote_average)
        self.originalCountries = try? values.decode([Country].self, forKey: .production_countries)
    }
    
    static func getFakeMovies () -> [Movie] {
       return []
    }
}

struct TvShow: MediaData, Decodable {
    var id: Int
    var imageUrl: String?
    var bigImageUrl: String?
    var title: String
    var date: String?
    var genres: [Genre] = []
    var status: String?
    var initialLanguage: String?
    var overview: String
    var numberOfEpisodes: Int?
    var numberOfSeasons: Int?
    var voteAverage: Double
    var originalCoutries: [String]?
    
    enum CodingKeys: CodingKey {
        case backdrop_path, genre_ids, id, original_language, poster_path, first_air_date,  status, name, overview, number_of_episodes, number_of_seasons, vote_average, origin_country
    }
    
    var hasFacts: Bool {
        return numberOfEpisodes != nil && numberOfSeasons != nil && originalCoutries != nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.title = (try? values.decode(String.self, forKey: .name)) ?? ""
        self.date = try? values.decode(String.self, forKey: .first_air_date)
        self.initialLanguage = try? values.decode(String.self, forKey: .original_language)
        self.overview = (try? values.decode(String.self, forKey: .overview)) ?? ""
        self.numberOfSeasons = try? values.decode(Int.self, forKey: .number_of_seasons)
        self.numberOfEpisodes = try? values.decode(Int.self, forKey: .number_of_episodes)
        
        self.imageUrl = ImageSize.poster.getURL(imagePath: (try? values.decode(String.self, forKey: .poster_path)) ?? "")
        self.bigImageUrl = ImageSize.wallpaper.getURL(imagePath: (try? values.decode(String.self, forKey: .backdrop_path)) ?? "")
        self.genres = ((try? values.decode([Int].self, forKey: .genre_ids)) ?? []).map {
            AppStore.shared.getGenre(from: $0)
        }
        self.voteAverage = try values.decode(Double.self, forKey: .vote_average)
        self.originalCoutries = try? values.decode([String].self, forKey: .origin_country)
    }
}
