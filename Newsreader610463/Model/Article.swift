//
//  Article.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct Article: Decodable, Identifiable {
    
    let id: Int
    let title: String
    let image: URL?
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case image = "Image"
        case isLiked = "IsLiked"
    }
    
}
