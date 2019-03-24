//
//  SpotifyAPI.swift
//  smore
//
//  Created by Jing Wei Li on 2/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire

class SpotifyAPI {
    
    private static let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    static func getCategories(token: String) {
        let searchQuery = "https://api.spotify.com/v1/browse/categories"
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(token)"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print("JSON Request failed")
                    }
                    return
                }
                if let data = json.data {
                    do {
                        print(data)
                        let result = try decoder.decode(SPTCategory.self, from: data)
                        DispatchQueue.main.async { print(result) }
                    } catch let err {
                        print(data)
                        print(err)
                    }
                } else {
                    DispatchQueue.main.async {
                        print("JSON Corrupted")
                    }
                }
        }
    }
    
}
