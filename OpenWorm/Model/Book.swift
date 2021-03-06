//
//  Book.swift
//  OpenWorm
//
//  Created by Pierre-Jean QuillerĂ© on 2021-10-17.
//

import Foundation

struct Book: Codable, Hashable {
    let key: String
    let title: String
    let authorNames: [String]?
    let ISBNs: [String]?
    
    var copy = 0
    
    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorNames = "authorName"
        case ISBNs = "isbn"
    }
    
    struct Response: Codable {
        let docs: [Book]
    }
}
