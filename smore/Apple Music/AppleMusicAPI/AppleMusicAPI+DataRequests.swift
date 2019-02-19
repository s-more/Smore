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
    
    // MARK: - Data Requests Enums
    
    enum APMLibrarySearchMode: String {
        case songs = "library-songs"
        case albums = "library-albums"
        case playlists = "library-playlists"
        case artists = "library-artists"
        case musicVideos = "library-music-videos"
    }
    
    enum APMCatalogSearchMode: String {
        case songs = "songs"
        case albums = "albums"
        case playlists = "playlists"
        case artists = "artists"
        //case musicVideos = "music-videos"
    }
    
    enum APMTopChartMode: String {
        case songs = "songs"
        case albums = "albums"
        // case musicVideos = "music-videos"
    }
    
    enum APMCatalogGenre: Int {
        case blues = 2
        case comedy = 3
        case children = 4
        case classical = 5
        case country = 6
        case electronic = 7
        case holiday = 8
        case singerSongwriter = 10
        case jazz = 11
        case latino = 12
        case pop = 14
        case rnbSoul = 15
        case soundtrack = 16
        case dance = 17
        case hipHopRap = 18
        case world = 19
        case alternative = 20
        case rock = 21
        case christianGospel = 22
        case reggae = 24
    }
    
    // MARK: - Data Requests Methods
    
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
        types: [APMCatalogSearchMode] = [.artists, .albums, .playlists, .songs],
        limit: Int = 5,
        success: @escaping (APMSearch.APMSearchResults) -> Void,
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
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        error(NSError(domain: "JSON Request Failed", code: 0))
                    }
                    return
                }
                if let data =  json.data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let result = try decoder.decode(APMSearch.self, from: data)
                        DispatchQueue.main.async { success(result.results) }
                    } catch let err {
                        DispatchQueue.main.async { error(err) }
                    }
                } else {
                    DispatchQueue.main.async {
                        error(NSError(domain: "JSON Corrupted", code: 0))
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
        from term: String,
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
                if let err = json.error {
                    DispatchQueue.main.async { error(err) }
                    return
                }
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
    
    /**
     Get the top charts data for the given modes and genres using the Apple Music API.
        - the completion closure is not called on the main thread.
     - parameter modes: top chart for the songs, or top charts for the albums?
     - parameter genre: spefify a genre for the top chart. Use `nil` when getting top charts for all genres.
     - parameter limit: max length of items of the response. Defaults to 10.
     - parameter success: the closure called when search succeeds.
     - parameter error: the closure called when search fails.
     */
    static func topCharts(
        for modes: [APMTopChartMode],
        genre: APMCatalogGenre?,
        limit: Int = 20,
        completion: @escaping (APMTopChartResponse.APMTopChartResonseResults) -> Void,
        error: @escaping (Error) -> Void)
    {
        var query =
            ["https://api.music.apple.com/v1/catalog/\(countryCode)/charts",
             "?types=\(Array(Set(modes)).map { $0.rawValue }.joined(separator: ","))",
             "&limit=\(limit)"].joined()
        
        if let genre = genre {
            query.append("&genre=\(genre.rawValue)")
        }
        
        Alamofire.request(
            query,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaders)
            .responseJSON { json in
                if let err = json.error {
                    DispatchQueue.main.async { error(err) }
                    return
                }
                if let data =  json.data {
                    do {
                        let response = try JSONDecoder().decode(APMTopChartResponse.self, from: data)
                        completion(response.results)
                    } catch let err {
                        DispatchQueue.main.async { error(err) }
                    }
                } else {
                    DispatchQueue.main.async {
                        error(NSError(domain: "Invalid JSON", code: 0, userInfo: nil))
                    }
                }
        }
    }
    
    static func genreIDs(
        for genres: [Int],
        completion: @escaping (String) -> Void) {
        let query =
            ["https://api.music.apple.com/v1/catalog/\(countryCode)/genres",
            "?ids=\(genres.map { "\($0)" }.joined(separator: ","))"].joined()
        Alamofire.request(
            query,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaders)
            .responseJSON { json in
                if let stringData =  json.data,
                    let result = String(data: stringData, encoding: String.Encoding.utf8) {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
        }
    }
}
