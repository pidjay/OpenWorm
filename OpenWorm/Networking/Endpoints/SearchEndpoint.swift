//
//  SearchEndpoint.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import Foundation

enum SearchEndpoint: APIEndPoint {
    case query(String)
    
    var path: String {
        switch self {
        case .query(_):
            return "/search.json"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .query(let query):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "limit", value: "35"),
            ]
        }
    }
}
