//
//  HomepageView.swift
//  Newsreader610463
//
//  Created by Vicente on 22/10/2020.
//

import SwiftUI

struct HomepageView: View {
    
    //@State var articles: [Article]? = nil
    
    @ObservedObject var articles: ArticlesObservable = ArticlesObservable()
    
    var body: some View {
        
        VStack{
            
            if articles.items.count > 0 {
                ArticlesListView(articles: self.articles)
            } else {
                ProgressView("Loadig articles...")
                    .onAppear {
                        self.articles.fetchArticles()
                    }
            }
        }.navigationTitle("List of articles")
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
