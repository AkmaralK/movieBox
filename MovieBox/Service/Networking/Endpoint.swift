//
//  Endpoints.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/28/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

enum Endpoint {
    
    // MARK; - List of Movies
    
    case getTopRated (apiKey: String, language: String, page: Int)
    case getUpcoming (apiKey: String, language: String, page: Int)
    
    
    var baseURL: String {
        return "api.themoviedb.org"
    }
    
    var path: String {
        switch self {
            case .getTopRated(_, _, _):
                return "/3/movie/top_rated"
            case .getUpcoming(_, _, _):
                return "/movie/upcoming"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
            case .getTopRated(apiKey: let key, language: let language, let page):
                return [
                    URLQueryItem(name: "apiKey", value: key),
                    URLQueryItem(name: "q", value: quoteStr),
                    URLQueryItem(name: "page", value: "\(page)")
                ]
            case .getUpcoming(apiKey: let key, language: let language, let page):
                return [
                    URLQueryItem(name: "apiKey", value: key),
                    URLQueryItem(name: "q", value: quoteStr),
                    URLQueryItem(name: "page", value: "\(page)")
                ]
        }
    }
}
