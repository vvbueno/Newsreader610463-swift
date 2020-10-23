//
//  HomepageView.swift
//  Newsreader610463
//
//  Created by Vicente on 22/10/2020.
//

import SwiftUI

struct HomepageView: View {
    
    @State var articles: [Article]? = nil
    
    var body: some View {
        
        VStack{
            if let articles = articles {
                ArticlesListView(articles: articles)
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
        }.navigationTitle("List of articles")
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
