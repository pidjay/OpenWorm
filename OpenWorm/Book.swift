//
//  Book.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import Foundation

struct Book: Codable {
    let title: String
    let authorNames: [String]?
    let ISBNs: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorNames = "authorName"
        case ISBNs = "isbn"
    }
    
    struct Response: Codable {
        let docs: [Book]
    }
}
