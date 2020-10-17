//
//  GetArticleDetailsResponse.swift
//  Newsreader610463
//
//  Created by Vicente on 17/10/2020.
//

import Foundation

struct GetArticlesDetailsResponse: Decodable {
    
    let articles: [ArticleDetails]
    let nextArticleId: Int
    
    enum CodingKeys: String, CodingKey {
        case articles = "Results"
        case nextArticleId = "NextId"
    }
    
}
