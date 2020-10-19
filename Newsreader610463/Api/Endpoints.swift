//
//  Endpoints.swift
//  Newsreader610463
//
//  Created by Vicente on 19/10/2020.
//

import Foundation

struct Endpoints {
    
    static let apiUrl = "https://inhollandbackend.azurewebsites.net/api"
    
    struct Authentication {
        static let login = apiUrl + "/Users/login"
        static let register = apiUrl + "/Users/register"
    }
    
    struct Articles {
        static let getArticles = apiUrl + "/Articles"
        static let getArticle = apiUrl + "/Articles/{id}"
        static let getLikedArticles = apiUrl + "/Articles/liked"
        static let likeArticle = apiUrl + "/Articles/{id}/like"
    }
    
    struct Feeds {
        static let getFeeds = apiUrl + "/Feeds"
    }
}
