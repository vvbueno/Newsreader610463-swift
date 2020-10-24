//
//  FavoritesView.swift
//  Newsreader610463
//
//  Created by Vicente on 22/10/2020.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var newsReaderApi = NewsReaderAPI.shared
    
    @ObservedObject var articlesViewModel: FavoriteArticlesViewModel = FavoriteArticlesViewModel()
    
    var body: some View {
        
        VStack {
            if newsReaderApi.isAuthenticated{
                if articlesViewModel.articles != nil && articlesViewModel.isLoading == false {
                    
                    if(articlesViewModel.articles!.count > 0){
                        ArticlesListView(articlesViewModel: self.articlesViewModel)
                    }else{
                        Text("fav_articles_not_found")
                    }
                } else {
                    ProgressView("loading_fav_articles")
                        .onAppear {
                            self.articlesViewModel.fetchLikedArticles()
                        }
                }
            } else {
                Text("log_in_fav_articles")
            }
        }.navigationTitle("favorite_articles")
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
