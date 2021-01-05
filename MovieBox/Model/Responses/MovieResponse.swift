//
//  MovieResponse.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/31/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

struct MediaDataResponseShape<T: MediaData>: Decodable {
    var results: [T]
    
    var total_pages: Int
    
    func convertedToResponse () -> MediaDataResponse {
        return MediaDataResponse(
            results: results,
            total_pages: total_pages
        )
    }
}

struct MediaDataResponse {
    
    var results: [MediaData]
    
    var total_pages: Int
}


