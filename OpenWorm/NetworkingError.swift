//
//  NetworkingError.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL(String)
    case unableToComplete
    case invalidResponse(HTTPURLResponse?)
    case invalidData(Data?)
}
