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
    
    @ObservedObject var newsReaderApi = NewsReaderAPI.shared
    
    @ObservedObject var articlesViewModel: ArticlesViewModel
    
    @State var articleDetails: ArticleDetails? = nil
        
    @State var isLikeButtonPressed: Bool = false
    
    @State var isTryingToLike: Bool = false
    
    @State var isRequestErrorViewPresent: Bool = false
    @State var requestErrorViewMessage: String? = nil
    
    init(article : Article, articlesViewModel: ArticlesViewModel) {
        self.article = article
        self.articlesViewModel = articlesViewModel
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
                            
                            if newsReaderApi.isAuthenticated{
                                ZStack {
                                    Image(systemName: "heart.fill")
                                        .opacity(isLikeButtonPressed ? 1 : 0)
                                        .scaleEffect(isLikeButtonPressed ? 1.0 : 0.1)
                                        .foregroundColor(.red)
                                        .animation(.linear)
                                    Image(systemName: "heart")
                                        .foregroundColor(.gray)
                                }.font(.system(size: 40))
                                    .onTapGesture {
                                        if(!self.isTryingToLike){
                                            print("liking article")
                                            self.isTryingToLike = true
                                            NewsReaderAPI.shared.likeArticle(of: article) { (result) in
                                                switch result {
                                                case .success(_):
                                                    self.isLikeButtonPressed.toggle()
                                                    self.articlesViewModel.updateArticle(articleId: articleDetails.id, liked: self.isLikeButtonPressed)
                                                case .failure(_):
                                                    isRequestErrorViewPresent = true
                                                    requestErrorViewMessage = "error_liking"
                                                }
                                                self.isTryingToLike = false
                                            }
                                        }
                                }
                            }
                    
                        }.padding()

                        VStack(alignment: .leading){
                            
                            Text(articleDetails.summary!)
                                .font(.body)
                              .padding()
                            
                            VStack(alignment: .leading){
                                Text("read_full_article")
                                Button(action: {
                                    UIApplication.shared.open(articleDetails.url)
                                }) {
                                    Text(articleDetails.url.absoluteString)
                                }
                            }.padding()
                            
                        }.padding()
                    }
                }.padding()
                
            } else {
                ProgressView("loading_article_details")
                    .onAppear {
                        NewsReaderAPI.shared.getArticleDetails(of: article) { (result) in
                            switch result {
                            case .success(let result):
                                self.articleDetails = result.articles.first
                            case .failure(_):
                                isRequestErrorViewPresent = true
                                requestErrorViewMessage = "error_fetching_article"
                                self.mode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: MyBackButton(label: "back") {
            
            if (self.articlesViewModel is FavoriteArticlesViewModel) {
                self.articlesViewModel.removeUnlikedArticles()
            }
            
            self.mode.wrappedValue.dismiss()
        }).padding()
        .alert(isPresented: $isRequestErrorViewPresent){
            Alert(title: Text("failure"), message: Text(requestErrorViewMessage ?? "generic_error"), dismissButton: .default(Text("OK")))
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
