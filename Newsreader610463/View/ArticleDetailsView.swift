//
//  ArticleDetailsView.swift
//  Newsreader610463
//
//  Created by Vicente on 16/10/2020.
//

import SwiftUI

struct ArticleDetailsView: View {
        
    var article: Article
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var articlesViewModel: ArticlesViewModel
    
    @State var articleDetails: ArticleDetails? = nil
        
    @State var isLikeButtonPressed: Bool = false
    
    @State var isTryingToLike: Bool = false
    
    init(article : Article, articlesViewModel: ArticlesViewModel) {
        self.article = article
        self.articlesViewModel = articlesViewModel
        // use this to initialize
        self._isLikeButtonPressed = State(initialValue: article.isLiked)
    }
    
    var body: some View {
        
        VStack{
            if let articleDetails = articleDetails {
                
                ScrollView{
                    VStack(alignment: .center, spacing:2.5) {
                        
                      UrlImageView(url: articleDetails.image, width: 256, height: 256)
                        .padding()
                                            
                        HStack(spacing:20){
                            Text(articleDetails.title)
                                .font(.title3)
                                .fontWeight(.medium)
                                .frame(maxWidth: 200)
                            
                            ZStack {
                                Image(systemName: "heart.fill")
                                    .opacity(isLikeButtonPressed ? 1 : 0)
                                    .scaleEffect(isLikeButtonPressed ? 1.0 : 0.1)
                                    .animation(.linear)
                                Image(systemName: "heart")
                                    .foregroundColor(.gray)
                            }.font(.system(size: 40))
                                .onTapGesture {
                                    if(!self.isTryingToLike){
                                        self.isTryingToLike = true
                                        NewsReaderAPI.shared.likeArticle(of: article) { (result) in
                                            switch result {
                                            case .success(_):
                                                self.isLikeButtonPressed.toggle()
                                                self.articlesViewModel.updateArticle(articleId: articleDetails.id, liked: self.isLikeButtonPressed)
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
                                            self.isTryingToLike = false
                                        }
                                    }
                            }
                            .foregroundColor(self.articleDetails!.isLiked ? .red : .white)
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
    }.navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: MyBackButton(label: "Back") {
        
        if (self.articlesViewModel is FavoriteArticlesViewModel) {
            self.articlesViewModel.removeUnlikedArticles()
        }
        
        self.mode.wrappedValue.dismiss()
    })
    }
}

/*
struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        ArticleDetailsView(article: article)
    }
}
*/
