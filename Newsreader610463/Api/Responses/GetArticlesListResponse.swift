//
//  GetArticlesResponse.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct GetArticlesListResponse: Decodable {
    
    let articles: [Article]
    let nextArticleId: Int
    
    enum CodingKeys: String, CodingKey {
        case articles = "Results"
        case nextArticleId = "NextId"
    }
    
}
