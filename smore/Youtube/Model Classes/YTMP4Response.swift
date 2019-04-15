//
//  YTMP4Response.swift
//  smore
//
//  Created by Vignesh Babu on 4/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct YTMP4Response: Codable {
    let url: URL?
    let mimeType: String?
    let quality: String?
    let qualityLabel: String?
    let width: Int?
    let height: Int?
    let audioQuality: String?
    let approxDurationMs: String?
}

