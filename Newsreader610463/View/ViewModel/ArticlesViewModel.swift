//
//  ArticlesViewModel.swift
//  Newsreader610463
//
//  Created by Vicente on 24/10/2020.
//

import Foundation
import Combine

class ArticlesViewModel: ObservableObject {
    
    @Published var articles: [Article]? = nil
    
    @Published var isLoading = false
    
    func updateArticle(articleId: Int, liked: Bool) {

        objectWillChange.send()
        
        self.articles = self.articles?.map{
            var mutableArticle = $0
            if $0.id == articleId {
                mutableArticle.isLiked = liked
            }
            return mutableArticle
        }
    }
    
    func appendNewArticle(article: Article) {
        objectWillChange.send()
        self.articles?.append(article)
    }
    
    func appendNewArticles(articles: [Article]) {
        objectWillChange.send()
    
        for article in articles {
            self.articles?.append(article)
        }
    }
    
    func fetchArticles() {
        
        self.isLoading = true
        
        if(self.articles == nil){
            self.articles = [Article]()
        }
        
        NewsReaderAPI.shared.getArticlesList() { (result) in
            self.handleApiResult(result: result)
            self.isLoading = false
        }
    }
    
    func refresh() {
        objectWillChange.send()
        self.isLoading = true
        
        self.articles?.removeAll()
        
        NewsReaderAPI.shared.getArticlesList() { (result) in
            self.handleApiResult(result: result)
            self.isLoading = false
        }
    }
    
    internal func handleApiResult(result: Result<GetArticlesListResponse, RequestError>){
        switch result {
        case .success(let result):
            self.appendNewArticles(articles: result.articles)
        case .failure(let error):
            print(error)
            self.appendNewArticles(articles: [])
        }
    }
        
    func removeUnlikedArticles() {
    }
}
