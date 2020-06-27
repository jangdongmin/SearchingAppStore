//
//  Review.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/27.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

//테스트용 입니다.
struct Review: Codable {
    let userName: String?
    let starRate: Double?
    let time: String?
    let content: String?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName
        case starRate
        case time
        case content
        case title
    }
    
    public init(userName: String, starRate: Double, time: String, content: String, title: String) {
        self.userName = userName
        self.starRate = starRate
        self.time = time
        self.content = content
        self.title = title
    }
}
