//
//  ArticleDetailsView.swift
//  Newsreader610463
//
//  Created by Vicente on 16/10/2020.
//

import SwiftUI

struct ArticleDetailsView: View {
    
    let article: Article
    
    @State var articleDetails: ArticleDetails? = nil
    
    var body: some View {
        if let articleDetails = articleDetails {
           Text("Pokedex #\(articleDetails.id)")
               .padding()
            Text("#\(articleDetails.title)")
                .padding()
            Text("#\(articleDetails.image?.absoluteString ?? "")")
                .padding()
        } else {
            ProgressView("Loadig details...")
                .onAppear {
                    NewsReaderAPI.shared.getArticleDetails(of: article) { (result) in
                        switch result {
                        case .success(let result):
                            self.articleDetails = result.articles.first
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
