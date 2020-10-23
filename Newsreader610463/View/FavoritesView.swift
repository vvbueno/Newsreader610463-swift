//
//  FavoritesView.swift
//  Newsreader610463
//
//  Created by Vicente on 22/10/2020.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var newsReaderApi = NewsReaderAPI.shared
    
    @State var articles: [Article]? = nil
    
    var body: some View {
        
        
        if newsReaderApi.isAuthenticated{
            VStack{
                if let articles = articles {
                    ArticlesListView(articles: articles)
                } else {
                    ProgressView("Loadig favorite articles...")
                        .onAppear {
                            NewsReaderAPI.shared.getLikedArticlesList() { (result) in
                                switch result {
                                case .success(let result):
                                    self.articles = result.articles
                                case .failure(let error):
                                    switch error {
                                    case .urlError(let urlError):
                                        print(urlError)
                                    case .decodingError(let decodingError):
                                        print(decodingError)
                                    case .genericError(let error):
                                        print(error)
                                    }
                                }
                            }
                        }
                }
            }.navigationTitle("List of favorite articles")
        } else {
            VStack {
                Text("Log in to see your favorite articles")
            }.navigationTitle("List of favorite articles")
        }
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
