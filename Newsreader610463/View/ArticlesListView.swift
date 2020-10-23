//
//  ArticlesListView.swift
//  Newsreader610463
//
//  Created by Vicente on 19/10/2020.
//

import SwiftUI

struct ArticlesListView: View {
    
    let articles: [Article]
    
    let columns = [
        GridItem(.adaptive(minimum: 250),
                 spacing: 0,
                 alignment: .topLeading)
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 0){
                ForEach(articles) { article in
                    NavigationLink(destination:
                        ArticleDetailsView(article: article)
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
