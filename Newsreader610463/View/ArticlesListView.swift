//
//  ArticlesListView.swift
//  Newsreader610463
//
//  Created by Vicente on 19/10/2020.
//

import SwiftUI

struct ArticlesListView: View {
    
    @State var articles: [Article]? = nil
    
    var columns = [
        GridItem(.adaptive(minimum: 250),
                 spacing: 0,
                 alignment: .topLeading)
    ]
    
    var body: some View {
        
        if let articles = articles {
            NavigationView{
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
                }.navigationTitle("Very tasty!")
            }
        } else {
            ProgressView("Loadig articles...")
                .onAppear {
                    NewsReaderAPI.shared.getArticlesList() { (result) in
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
        
    }
}

struct ArticlesListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView()
    }
}
