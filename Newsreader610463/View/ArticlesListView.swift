//
//  ArticlesListView.swift
//  Newsreader610463
//
//  Created by Vicente on 19/10/2020.
//

import SwiftUI

struct ArticlesListView: View {
    
    @ObservedObject var articles: ArticlesObservable
    
    let columns = [
        GridItem(.adaptive(minimum: 250),
                 spacing: 0,
                 alignment: .topLeading)
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 0){
                ForEach(articles.items) { article in
                    NavigationLink(destination:
                                    ArticleDetailsView(article: article, model: self.articles).environmentObject(self.articles)
                            .navigationTitle(article.title)
                    ) {
                        AritcleRowView(article: article)
                            .padding()
                    }
                }
            }
        }
    }
    
}
/*
struct ArticlesListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView()
    }
}
 */
