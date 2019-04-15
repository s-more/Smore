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
    
    enum SPTCatalogSearchMode: String {
        case tracks = "track"
        case albums = "album"
        case artists = "artist"
        case playlists = "playlist"
    }
    
    private static let developerToken = "BQDOAh52dyr_8nbDmGZ-hfySj4xbs-BsbvngWJCUjzRKOQ3h6lVBDS4xQztxcpAHH1G2pYY_fG9EGJvIbDbZNnGijV8CAAZkCf5LmjqpKaaAQ4KOsFle7FUdyKvqUJtl1jiZa_8Tsn-XttIQLtvnjmFMyig-w5fb3KMy-FuiF8CSpD0eyjf40YoJe2DWUjU_H1cwOkG1Vr8-zZQzP0FrjQhx5CqXXi30AizMAdFJlD-WLkHxK-R2Jc3dFK-CBHw"
    
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
    
    
    static func getAlbum(token: String,
                         albumID: String,
                         success: @escaping (SPTAlbumResponse) -> Void,
                         error: @escaping (Error) -> Void) {
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
                            success(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            error(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    static func getTrack(token: String, trackID: String) {
        let searchQuery = ["https://api.spotify.com/v1/tracks/", trackID].joined()
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
                        
                        let result = try decoder.decode(SPTTrackResponse.self, from: data)
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
    
    
    static func searchCatalog(token: String,
                              term: String,
                              types: [SPTCatalogSearchMode] = [.artists, .albums, .tracks, .playlists],
                              limit: Int = 3,
                              success: @escaping (SPTSearchResponse) -> Void,
                              error: @escaping (Error) -> Void) {
        let searchQuery = ["https://api.spotify.com/v1/search/?q=\(term.split(separator: " ").joined(separator: "+"))",
            "&type=\(types.map { $0.rawValue }.joined(separator: ","))",
            "&limit=\(limit)"].joined()
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

                        let result = try decoder.decode(SPTSearchResponse.self, from: data)
                        DispatchQueue.main.async {
                            success(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            error(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    static func getPlaylists(token: String,
                             playlistID: String,
                             completion: @escaping (SPTPlaylistResponse) -> Void,
                             error: @escaping (Error) -> Void) {
        let searchQuery = ["https://api.spotify.com/v1/playlists/", playlistID].joined()
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
                        
                        let result = try decoder.decode(SPTPlaylistResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            error(err)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    static func getTopArtists(token: String,
                        typeIsArtist: String,
                        completion: @escaping (SPTTopArtistResponse) -> Void,
                        error: @escaping (Error) -> Void) {
        let searchQuery = ["https://api.spotify.com/v1/me/top/", typeIsArtist].joined()
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
                        
                        let result = try decoder.decode(SPTTopArtistResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            error(err)
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
