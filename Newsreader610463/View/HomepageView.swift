//
//  HomepageView.swift
//  Newsreader610463
//
//  Created by Vicente on 22/10/2020.
//

import SwiftUI

struct HomepageView: View {
    
    @ObservedObject var articlesViewModel: ArticlesViewModel = ArticlesViewModel()
    
    var body: some View {
        
        VStack{
            
            if articlesViewModel.articles != nil && articlesViewModel.isLoading == false {
                
                if(articlesViewModel.articles!.count > 0){
                    ArticlesListView(articlesViewModel: self.articlesViewModel)
                }else{
                    Text("No articles lol")
                }
                
            } else {
                ProgressView("Loading articles...")
                    .onAppear {
                        self.articlesViewModel.fetchArticles()
                    }
            }
        }.navigationTitle("Latest articles")
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
