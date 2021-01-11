//
//  APIBase.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/28/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

extension URLSession {
    
    func request<T:Decodable> (
        for: T.Type = T.self,
        _ endpoint: Endpoint,
        returnJSON: Bool = false,
        completion: @escaping (Swift.Result<T, RequestError>) -> Void) {
        let request = createRequest(from: endpoint)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let jsonData = data else {
                    completion(.failure(.noData))
                    return
                }
                
                guard error == nil else {
                    completion(.failure(.withParameter(message: error!.localizedDescription)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let jsonResponse = try decoder.decode(T.self, from: jsonData)
                    completion(.success(jsonResponse))
                } catch let e {
                    print(e)
                    if let data = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary {
                        completion(.failure(.withDic(data: data)))
                    } else {
                        completion(.failure(.undefined))
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func requestJSON (
        _ endpoint: Endpoint,
        completion: @escaping (Swift.Result<[String: Any], RequestError>) -> Void)
    {
        let request = createRequest(from: endpoint)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let jsonData = data else {
                    completion(.failure(.noData))
                    return
                }
                
                guard error == nil else {
                    completion(.failure(.withParameter(message: error!.localizedDescription)))
                    return
                }
                
                if let dataResult = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    completion(.success(dataResult))
                } else {
                    completion(.failure(.undefined))
                }
            }
        }
        
        dataTask.resume()
    }
    
    func createRequest (from endpoint: Endpoint) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Endpoint.baseURL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
}
