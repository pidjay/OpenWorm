//
//  BookDetail.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import Foundation

struct BookDetail: Codable {
    #warning("TODO: get authors info but the API seems to have 2 different formats for that field... Author and AuthorKey")
    
    let covers: [Int]?
    let title: String
    let editionName: String?
//    let authors: [Author]?
    let publishers: [String]?
    let numberOfPages: Int?
    let ISBN10: [String]?
    let ISBN13: [String]?
    let publishDate: String?
    let physicalFormat: String?
    
    enum CodingKeys: String, CodingKey {
        case covers
        case publishers
        case title
        case numberOfPages
        case editionName
        case ISBN10 = "isbn10"
        case ISBN13 = "isbn13"
        case publishDate
//        case authors
        case physicalFormat
    }
    
    struct AuthorKey: Codable {
        let key: String
    }
    
    struct Author: Codable {
        let author: AuthorKey
    }
}
