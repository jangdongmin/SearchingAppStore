//
//  History.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

struct History: Codable {
    let name: String
    let webPages: [String]?
    let country: String

    private enum CodingKeys: String, CodingKey {
        case name
        case webPages = "web_pages"
        case country
    }
}
