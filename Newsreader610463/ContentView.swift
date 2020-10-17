//
//  ContentView.swift
//  Newsreader610463
//
//  Created by Vicente on 11/10/2020.
//

import SwiftUI

struct ContentView: View {
    
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
                                Text(article.title)
                                    .padding()
                            }
                        }
                    }
                }.navigationTitle("Very tasty!")
            }
        
        } else{
            ProgressView("Loadig articles...")
                .onAppear {
                    NewsReaderAPI.shared.getArticlesList() { (result) in
                        switch result {
                        case .success(let articles):
                            self.articles = articles
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
        
        /*
        List(articles) { article in
            NavigationLink(destination:
                ArticleDetailsView(article: article)
                    .navigationTitle(article.title)
            ) {
                Text(article.title)
                    .padding()
            }
        }.onAppear {
            ProgressView("Loadig articles...")
                .onAppear {
                    NewsReaderAPI.shared.getArticlesList() { (result) in
                        switch result {
                        case .success(let articles):
                            self.articles = articles
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
        */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
