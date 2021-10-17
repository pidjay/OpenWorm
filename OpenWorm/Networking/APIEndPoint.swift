//
//  APIEndPoint.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import Foundation

protocol APIEndPoint {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension APIEndPoint {
    var url: URL? {
        guard var components = URLComponents(string: APIConstant.baseURL) else { return nil }
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
