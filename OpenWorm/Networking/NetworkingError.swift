//
//  NetworkingError.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import Foundation

protocol UserFriendlyError: Error {
    var userFriendlyDescription: String { get }
}

enum NetworkingError: UserFriendlyError {
    case invalidURL(String)
    case unableToComplete
    case invalidResponse(HTTPURLResponse?)
    case invalidData(Data?)
    
    var userFriendlyDescription: String {
        switch self {
        case .invalidURL(_):
            return "This search created an invalid request. Please try again."
        case .unableToComplete:
            return "Unable to complete your request. Please check your internet connection."
        case .invalidResponse(_):
            return "Invalid response from the server. Please try again."
        case .invalidData(_):
            return "The data received from the server was invalid. Please try again."
        }
    }
}
