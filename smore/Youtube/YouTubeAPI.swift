//
//  YouTubeAPI.swift
//  smore
//
//  Created by sin on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire

class YouTubeAPI {
    static var api_key: String = "AIzaSyCLdSHGPi7LVvN8V2hwJiM2gUuWpbONjHM"
    //static var api_key: String = "AIzaSyBxAZ75VDQVxSaHr1YxAla2mKNKaXx9LsA"
    
    private static let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601 // <- this is not right
        return jsonDecoder
    }()
    
    class func getMP4(
        with URL: String,
        success: @escaping ([YTMP4Response]) -> Void,
        error: @escaping (Error) -> Void
        ) {
        let searchQuery = ["https://you-link.herokuapp.com/?url=", URL].joined()
        
        Alamofire.request(searchQuery, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Accept": "application/json"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "YT JSON Request Failed", code: 0))
                        //print(json)
                    }
                    return
                }
                if let data = json.data {
                    do {
                        print("--- Starting ---")
                        let result = try
                            decoder.decode([YTMP4Response].self, from: data)
                        DispatchQueue.main.async {
                            print("Success")
                            //print(result)
                            
//                            if let str_data = json.data, let utf8Text = String(data: str_data, encoding: .utf8) {
//                                print("Data \(utf8Text)")
//                            }
                            
                            success(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
//                            print("YT Error!")
                            error(NSError(domain: "YT MP4 Parse Failed", code: 0))
                            //print(json)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        error(NSError(domain: "YT JSON Corrupted", code: 0))
                    }
                }
        }
    }
    
    class func search(
        with text: String,
        limit: Int = 10,
        success: @escaping (YTSearchResults) -> Void,
        error: @escaping (Error) -> Void
    ) {

        let search_text = text.replacingOccurrences(of: " ", with: "%20")
        
        let searchQuery = ["https://www.googleapis.com/youtube/v3/search?part=snippet&q=", search_text, "&maxResults=", String(limit), "&key=", api_key ].joined()
        
        print("====== Attempting lookup ====")
        print(searchQuery)
        
        Alamofire.request(
            searchQuery,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Accept": "application/json"]).responseJSON
            { json in
                guard json.result.isSuccess else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "YT JSON Request Failed", code: 0))
                        //print(json)
                    }
                    return
                }
                if let data = json.data {
                    do {
                        print("--- Starting ---")
                        let result = try
                            decoder.decode(YTSearchResults.self, from: data)
                        DispatchQueue.main.async {
                            print("Success")
                            //print(result)
                            
                            if let str_data = json.data, let utf8Text = String(data: str_data, encoding: .utf8) {
                                print("Data \(utf8Text)")
                            }
                            
                            success(result)
                        }
                    } catch let err {
                        DispatchQueue.main.async {
                            print("YT Error!")
                            print(err)
                            //print(json)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(NSError(domain: "YT JSON Corrupted", code: 0))
                    }
                }
            }
        
    }
}
