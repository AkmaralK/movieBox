//
//  Seasons.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/6/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct Season: Decodable {
    var date: String
    var episodeCount: Int
    var id: Int
    var name: String
    var imageURL: String?
    
    enum CodingKeys: CodingKey {
        case air_date, episode_count, id, name, overview, poster_path
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _imagePoster = try? values.decode(String.self, forKey: .poster_path) {
            self.imageURL = ImageSize.bigPoster.getURL(imagePath: _imagePoster)
        }
        
        self.name = try values.decode(String.self, forKey: .name)
        self.id = try values.decode(Int.self, forKey: .id)
        self.episodeCount = try values.decode(Int.self, forKey: .episode_count)
        self.date = try values.decode(String.self, forKey: .air_date)
    }
}
