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
    
    static func getCategories(
        token: String,
        limit: Int?,
        offset: Int?,
        success: @escaping (SPTCategoryResponse) -> Void,
        error: @escaping (Error) -> Void) {
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
                        let result = try decoder.decode(SPTCategoryResponse.self, from: data)
                        DispatchQueue.main.async { success(result) }
                    } catch let err {
                        DispatchQueue.main.async {
                            error(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("JSON Corrupted")
                    }
                }
        }
    }
    
    
    static func getNewReleases(token: String) {
        let searchQuery = "https://api.spotify.com/v1/browse/new-releases"
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(token)"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Request Failed", code: 0))
                    }
                    return
                }
                if let data = json.data {
                    do {
                        let result = try decoder.decode(SPTNewReleasesResponse.self, from: data)
                        DispatchQueue.main.async {
                            print(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            print(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    
    static func getArtist(token: String, artistID: String) {
        let searchQuery = ["https://api.spotify.com/v1/artists/", artistID].joined()
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(token)"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Request Failed", code: 0))
                    }
                    return
                }
                if let data = json.data {
                    do {
                        let result = try decoder.decode(SPTArtistResponse.self, from: data)
                        DispatchQueue.main.async {
                            print(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            print(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    static func getArtistAlbums(token: String, artistID: String) {
        let searchQuery = ["https://api.spotify.com/v1/artists/", artistID, "/albums"].joined()
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(token)"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Request Failed", code: 0))
                    }
                    return
                }
                if let data = json.data {
                    do {
                        let result = try decoder.decode(SPTArtistAlbumsResponse.self, from: data)
                        DispatchQueue.main.async {
                            print(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            print(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    static func getArtistTopTracks(token: String, artistID: String) {
        let searchQuery = ["https://api.spotify.com/v1/artists/", artistID, "/top-tracks?country=US"].joined()
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(token)"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Request Failed", code: 0))
                        print(json)
                    }
                    return
                }
                if let data = json.data {
                    do {
                        
                        let result = try decoder.decode(SPTArtistTopTracksResponse.self, from: data)
                        DispatchQueue.main.async {
                            print(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            print(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    
    static func getAlbum(token: String, albumID: String) {
        let searchQuery = ["https://api.spotify.com/v1/albums/", albumID].joined()
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(token)"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Request Failed", code: 0))
                        print(json)
                    }
                    return
                }
                if let data = json.data {
                    do {
                        
                        let result = try decoder.decode(SPTAlbumResponse.self, from: data)
                        DispatchQueue.main.async {
                            print(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            print(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
}
