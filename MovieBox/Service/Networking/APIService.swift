//
//  APIService.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/29/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SVProgressHUD

final class ApiService {
    static let shared = ApiService()
    
    private let apiKey = "bcd3c6393606f8cd9ab1c236f6d4e0ea"
    
    func loadTopRatedMovies (
        page: Int = 1,
        complitionHandler: @escaping (([Movie])-> Void),
        complitionHandlerError: @escaping ((String) -> Void)
    ) {
        let endpoint = Endpoint.getTopRated(apiKey: apiKey, language: "en", page: page)
        SVProgressHUD.show()
        URLSession.shared.request(for: [Movie].self, endpoint) { (result) in
            SVProgressHUD.dismiss()
            switch (result) {
            case .success(let movies):
                complitionHandler(movies)
            case .failure(let err):
                complitionHandlerError(err.errorMsg)
            }
        }
    }
}
