//
//  CoverEndpoint.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-18.
//

import Foundation

enum CoverEndpoint: APIEndPoint {
    
    enum Size: String {
        case small  = "S"
        case medium = "M"
        case large  = "L"
    }
    
    case id(Int, Size)
    case isbn(String, Size)
}

extension CoverEndpoint {
    
    var path: String {
        switch self {
        case .id(let key, let size):
            return "/b/id/\(key)-\(size.rawValue).jpg"
        case .isbn(let key, let size):
            return "/b/isbn/\(key)-\(size.rawValue).jpg"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var baseURL: String {
        APIConstant.coverBaseURL
    }
}
