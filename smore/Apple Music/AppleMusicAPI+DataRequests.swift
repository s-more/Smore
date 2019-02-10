//
//  AppleMusicAPI+DataRequests.swift
//  smore
//
//  Created by Jing Wei Li on 2/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire


extension AppleMusicAPI {
    
    // MARK: Data Requests
    
    enum AppleMusicLibrarySearchMode: String {
        case songs = "library-songs"
        case albums = "library-albums"
        case playlists = "library-playlists"
        case artists = "library-artists"
        case musicVideos = "library-music-videos"
    }
    
    enum AppleMusicCatalogSearchMode: String {
        case songs = "songs"
        case albums = "albums"
        case playlists = "playlists"
        case artists = "artists"
        case musicVideos = "music-videos"
    }
    
    /**
     Search the apple music catalog for relevant information.
     - parameter term: the string to search the catalog.
     - parameter types: array of types of music to search.
     - parameter limit: max length of items of the response. Defaults to 5.
     - parameter success: the closure called when search succeeds.
     - parameter error: the closure called when search fails.
     */
    static func searchCatalog(
        with term: String,
        types: [AppleMusicCatalogSearchMode],
        limit: Int = 5,
        success: @escaping (String) -> Void,
        error: @escaping (Error) -> Void)
    {
        let searchQuery = ["https://api.music.apple.com/v1/catalog/\(countryCode)/search",
                           "?term=\(term.split(separator: " ").joined(separator: "+"))",
                           "&types=\(types.map { $0.rawValue }.joined(separator: ","))",
                           "&limit=\(limit)"]
                           .joined()
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaders).responseJSON
            { json in
            if let stringData =  json.data,
                let result = String(data: stringData, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async {
                    success(result)
                }
            }
        }
    }
    
    /**
     Get search hints following the given `term` using the Apple Music API.
     - Sample result passed into the success closure after searching for `"Halsey"`:
     ```
     ["halsey", "halsey without", "halsey essentials", "halsey juice wrld", "halsey without me clean"]
     ```
     - parameter term: the string used to get hints.
     - parameter limit: max length of items of the response. Defaults to 10.
     - parameter success: the closure called when search succeeds.
     - parameter error: the closure called when search fails.
     */
    static func searchHints(
        with term: String,
        limit: Int = 10,
        success: @escaping ([String]) -> Void,
        error: @escaping (Error) -> Void)
    {
        let searchQuery =
            ["https://api.music.apple.com/v1/catalog/\(countryCode)/search/hints",
            "?term=\(term.split(separator: " ").joined(separator: "+"))",
            "&limit=\(limit)"]
            .joined()
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaders).responseJSON
            { json in
            if let data =  json.data {
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let terms = jsonObj as? [String: [String: [String]]],
                        let results = terms["results"]?["terms"] else {
                            DispatchQueue.main.async { error(NSError(domain: "JSON Corrupted", code: 0)) }
                            return
                    }
                    DispatchQueue.main.async { success(results) }
                } catch let err {
                    DispatchQueue.main.async { error(err) }
                }
            } else {
                DispatchQueue.main.async { error(NSError(domain: "Invalid Data", code: 0)) }
            }
        }
    }
    
    static func requestData(with query: String, completion: @escaping (String) -> Void) {
        
        Alamofire.request(
            query,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaders).responseJSON
            { json in
            if let stringData =  json.data,
                let result = String(data: stringData, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
