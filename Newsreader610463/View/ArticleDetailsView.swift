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
    
    var likeIcon: String {
        return article.isLiked ? "heart.fill" : "heart"
    }
    
    var likeColor: Color {
        return article.isLiked ? .red : .gray
    }
    
    var body: some View {
        
        if let articleDetails = articleDetails {

            ScrollView{
                VStack(alignment: .center, spacing:5) {
                    
                  UrlImageView(url: articleDetails.image, width: 256, height: 256)
                    .padding()
                    
                    HStack(spacing:15){
                        Text(articleDetails.title)
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(maxWidth: 200)
                        
                        Image(systemName: likeIcon)
                            .resizable()
                            .frame(width: 36, height: 36)
                            .foregroundColor(likeColor)

                    }.padding()

  
                    
                    VStack(alignment: .leading){
                        
                        Text(articleDetails.summary!)
                            .font(.body)
                          .padding()
                        
                        VStack(alignment: .leading){
                            Text("Read full article at: ")
                            Button(action: {
                                UIApplication.shared.open(articleDetails.url)
                            }) {
                                Text(articleDetails.url.absoluteString)
                            }
                        }.padding()
                        
                    }.padding()
                }
            }
            
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

/*
struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        ArticleDetailsView(article: article)
    }
}
*/
