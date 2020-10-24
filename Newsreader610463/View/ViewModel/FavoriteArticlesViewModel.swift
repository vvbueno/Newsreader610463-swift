//
//  FavoriteArticlesViewModel.swift
//  Newsreader610463
//
//  Created by Vicente on 24/10/2020.
//

import Foundation
import Combine

class FavoriteArticlesViewModel: ArticlesViewModel {
    
    override func removeUnlikedArticles() {
        objectWillChange.send()
        self.articles = self.articles?.filter { $0.isLiked != false }
    }
    
    func fetchLikedArticles() {
        
        self.isLoading = true
        
        if(self.articles == nil){
            self.articles = [Article]()
        }
        
        NewsReaderAPI.shared.getLikedArticlesList() { (result) in
            self.handleApiResult(result: result)
            self.isLoading = false
        }
    }
}
