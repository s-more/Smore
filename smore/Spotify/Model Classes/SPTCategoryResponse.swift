//
//  SPTCategoryResponse.swift
//  smore
//
//  Created by Colin Williamson on 3/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct SPTCategoryResponse: Codable {
    let categories: SPTCategory?
    struct SPTCategory: Codable {
        let href: String?
        let items: [SPTItem]?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        
        struct SPTItem: Codable {
            let href: String?
            let icons: [SPTIcon]?
            let id: String?
            let name: String?
            
            
            struct SPTIcon: Codable {
                let height: Int?
                let url: String?
                let width: Int?
            }
        }
    }
}
