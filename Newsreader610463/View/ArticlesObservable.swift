//
//  ArticlesObservable.swift
//  Newsreader610463
//
//  Created by Vicente on 24/10/2020.
//

import Foundation

class ArticlesObservable: ObservableObject {
    
    @Published var items = [Article]()
    
    @Published var isLoading = false
    
    
    func updateArticle(articleId: Int, liked: Bool) {
        //articles.filter {$0.id == article.id}.first?.isLiked = false
        //self.articles.filter({$0.id == article.id}).first?.isLiked = false
        objectWillChange.send()
        self.items = self.items.map{
            var mutableArticle = $0
            if $0.id == articleId {
                mutableArticle.isLiked = liked
            }
            return mutableArticle
        }
    }
    
    func appendNewArticle(article: Article) {
        objectWillChange.send()
        items.append(article)
    }
    
    func appendNewArticles(articles: [Article]) {
        objectWillChange.send()
    
        for article in articles {
            items.append(article)
        }
    }
    
    func fetchArticles() {
        
        self.isLoading = true
        
        NewsReaderAPI.shared.getArticlesList() { (result) in
            switch result {
            case .success(let result):
                self.appendNewArticles(articles: result.articles)
            case .failure(let error):
                switch error {
                case .urlError(let urlError):
                    print(urlError)
                    self.appendNewArticles(articles: [])
                case .decodingError(let decodingError):
                    print(decodingError)
                    self.appendNewArticles(articles: [])
                case .genericError(let error):
                    print(error)
                    self.appendNewArticles(articles: [])
                }
            }
            self.isLoading = false
        }
    }
}
