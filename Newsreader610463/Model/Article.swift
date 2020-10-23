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
    
    static let testData = [
        Article(id:134068,title: "Article 1", image: URL(string: "https://media.nu.nl/m/bd6xpyzaw32r_sqr256.jpg/brighton-predikt-voorzichtigheid-met-valse-start-maken-we-levens-kapot.jpg"), isLiked: false),
        Article(id:134067,title: "Article 2", image: nil, isLiked: true),
        Article(id:134066,title: "Article 3", image: URL(string: "https://media.nu.nl/m/bd6xpyzaw32r_sqr256.jpg/brighton-predikt-voorzichtigheid-met-valse-start-maken-we-levens-kapot.jpg"), isLiked: false),
        Article(id:134065,title: "Article 4", image: nil, isLiked: true)
    ]
    
}
