//
//  BookEndpoint.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-18.
//

import Foundation

enum BookEndpoint: APIEndPoint {
    case book(String)
    
    var path: String {
        switch self {
        case .book(let key):
            return "\(key).json"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
