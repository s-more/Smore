//
//  AppleMusicAPI+DataRequests.swift
//  smore
//
//  Created by Jing Wei Li on 2/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire

typealias APMRecommendationData = APMRecommendationResponse.APMRecommendationWrapperData
    .APMRecommendationRelationships.APMRecommendationContents.APMRecommendationData

extension AppleMusicAPI {
    
    private static let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
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
    
    // MARK: - Data Requests Methods
    
     ///Search the apple music catalog for relevant information.
     ///- parameter term: the string to search the catalog.
     ///- parameter types: array of types of music to search.
     ///- parameter limit: max length of items of the response. Defaults to 5.
     ///- parameter success: the closure called when search succeeds.
     ///- parameter error: the closure called when search fails.
    static func searchCatalog(
        with term: String,
        types: [APMCatalogSearchMode] = [.artists, .albums, .playlists, .songs],
        limit: Int = 3,
        success: @escaping (APMSearch.APMSearchResults) -> Void,
        error: @escaping (Error) -> Void
    ) {
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
    
    
     /// Get search hints following the given `term` using the Apple Music API.
     ///- Sample result passed into the success closure after searching for `"Halsey"`:
     ///```
     /// ["halsey", "halsey without", "halsey essentials", "halsey juice wrld", "halsey without me clean"]
     ///```
     ///- parameter term: the string used to get hints.
     ///- parameter limit: max length of items of the response. Defaults to 10.
     ///- parameter success: the closure called when search succeeds.
     ///- parameter error: the closure called when search fails.
    static func searchHints(
        from term: String,
        limit: Int = 10,
        success: @escaping ([String]) -> Void,
        error: @escaping (Error) -> Void
    ) {
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
    
    
     /// Get the top charts data for the given modes and genre using the Apple Music API.
     ///   - the completion closure is not called on the main thread.
     ///- parameter modes: top chart for the songs, or top charts for the albums?
     ///- parameter genre: spefify a genre for the top chart. Use `nil` when getting top charts for all genres.
     ///- parameter limit: max length of items of the response. Defaults to 10.
     ///- parameter success: the closure called when search succeeds.
     ///- parameter error: the closure called when search fails.
    static func topCharts(
        for modes: [APMTopChartMode],
        genre: APMCatalogGenre?,
        limit: Int = 20,
        completion: @escaping (APMTopChartResponse.APMTopChartResonseResults) -> Void,
        error: @escaping (Error) -> Void
    ) {
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
            headers: authHeaders
        ).responseJSON { json in
                if let err = json.error {
                    DispatchQueue.main.async { error(err) }
                    return
                }
                if let data =  json.data {
                    do {
                        let response = try decoder.decode(APMTopChartResponse.self, from: data)
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
    
    /// Fetch the content of a playlist, specified by its id, with the Apple Music API.
    ///- parameter id: the id of the playlist in the Apple Music Database.
    ///- parameter completion: the closure called when search succeeds.
    ///- parameter error: the closure called when search fails.
    static func playlists(
        with id: String,
        completion: @escaping (APMPlaylistResponse.APMPlaylistData) -> Void,
        error: @escaping (Error) -> Void)
    {
        Alamofire.request(
            "https://api.music.apple.com/v1/catalog/\(countryCode)/playlists/\(id)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaders).responseJSON
        { json in
            if let err = json.error {
                DispatchQueue.main.async { error(err) }
                return
            }
            if let data = json.data {
                do {
                    let response = try decoder.decode(APMPlaylistResponse.self, from: data)
                    if let result = response.data.first {
                        DispatchQueue.main.async { completion(result) }
                    }
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
    
    /// Fetch the content of an album, specified by its id, with the Apple Music API.
    ///- parameter id: the id of the album in the Apple Music Database.
    ///- parameter completion: the closure called when search succeeds.
    ///- parameter error: the closure called when search fails.
    static func album(
        with id: String,
        completion: @escaping (APMAlbumResponse.APMAlbumData) -> Void,
        error: @escaping (Error) -> Void)
    {
        Alamofire.request(
            "https://api.music.apple.com/v1/catalog/\(countryCode)/albums/\(id)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaders).responseJSON
        { json in
            if let err = json.error {
                DispatchQueue.main.async { error(err) }
                return
            }
            if let data = json.data {
                do {
                    let response = try decoder.decode(APMAlbumResponse.self, from: data)
                    if let result = response.data.first {
                        DispatchQueue.main.async { completion(result) }
                    }
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
    
    static func recentPlayed(
        completion: @escaping ([APMRecentlyPlayedResponse.APMRecentlyPlayedResponseData]) -> Void,
        error: @escaping (Error) -> Void)
    {
        Alamofire.request(
            "https://api.music.apple.com/v1/me/recent/played",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaderWithUserToken)
            .responseJSON { json in
                if let err = json.error {
                    DispatchQueue.main.async { error(err) }
                    return
                }
                if let data = json.data {
                    do {
                        let response = try decoder.decode(APMRecentlyPlayedResponse.self, from: data)
                        DispatchQueue.main.async { completion(response.data) }
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
    
    static func recommendations(
        completion: @escaping ([APMRecommendationData]) -> Void,
        error: @escaping (Error) -> Void)
    {
        Alamofire.request(
            "https://api.music.apple.com/v1/me/recommendations",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: authHeaderWithUserToken)
            .responseJSON
        { json in
            if let err = json.error {
                DispatchQueue.main.async { error(err) }
                return
            }
            if let data = json.data {
                do {
                    let response = try decoder.decode(APMRecommendationResponse.self, from: data)
                    let result: [APMRecommendationData] = response.data
                            .compactMap { $0.relationships.contents?.data } // map to [[]]
                            .reduce([], +) // flatten
                    DispatchQueue.main.async { completion(result) }
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
}
