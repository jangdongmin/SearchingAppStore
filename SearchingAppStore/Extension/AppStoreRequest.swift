//
//  AppStoreRequest.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation

//https://itunes.apple.com/search?term=카카오뱅크&country=kr&entity=software
class AppStoreRequest: APIRequest {
    var method = RequestType.GET
    var path = "search"
    var parameters = [String: String]()

    init(term: String) {
        parameters["term"] = term
        parameters["country"] = "kr"
        parameters["entity"] = "software"
        parameters["limit"] = "200"
    }
}
