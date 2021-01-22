//
//  FavItem.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/22/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct FavItem {
    var id: Int
    var imageUrl: String?
    var title: String
    var mediaType: MediaType!
    
    init (id: Int, imageUrl: String, title: String, mediaType: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.mediaType = MediaType.allCases.first(where: { $0.key == mediaType })
    }
}
