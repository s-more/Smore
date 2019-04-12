//
//  YouTubeAPI.swift
//  smore
//
//  Created by sin on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class YouTubeAPI {
    static var api_key: String = "AIzaSyCLdSHGPi7LVvN8V2hwJiM2gUuWpbONjHM"
    
    class func performGetRequest( targetURL: URL!, completion: (_ data: Data?, _ HTTPStatusCode: Int, _ error: Error?) -> Void ) {
        
        var request = URLRequest(url: targetURL)
        request.httpMethod = "GET"
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        print("Here")
        let task = session.dataTask(with: targetURL, completionHandler:
        { ( data, response, error ) in
            if let data = data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                    print(stringData) // JSON
                }
            }
        })
        print("Testtttt")
//        let task = session.dataTask(request, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                completion(data: data, HTTPStatusCode: (response as! HTTPURLResponse).statusCode, error: error)
//            })
//        })
        
        task.resume()
        print("DONeee")
    }
    
    
    class func search(
        with text: String,
        limit: Int = 3,
        success: @escaping (YTSearchResults) -> Void,
        error: @escaping (Error) -> Void
    ) {

        let searchQuery = ["https://www.googleapis.com/youtube/v3/search", "?part=snippet", "&q=", text, "&key=", api_key ].joined()

        print("====== Attempting lookup ====")
        print(searchQuery)
        
        //performGetRequest(targetURL: URL(string: searchQuery), completion:  )
        
    }
}
