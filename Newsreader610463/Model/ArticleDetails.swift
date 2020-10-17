//
//  ArticleDetails.swift
//  Newsreader610463
//
//  Created by Vicente on 17/10/2020.
//

import Foundation

struct ArticleDetails: Decodable, Identifiable {
    
    let id: Int
    let feedId: Int?
    let title: String
    let publishDate: String
    let image: URL?
    let url: URL
    let related: [String]?
    let categories: [Category]?
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case feedId = "Feed"
        case title = "Title"
        case publishDate = "PublishDate"
        case image = "Image"
        case url = "Url"
        case related = "Related"
        case categories = "Categories"
        case isLiked = "IsLiked"
    }
    
}
