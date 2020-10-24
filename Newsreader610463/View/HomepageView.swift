//
//  HomepageView.swift
//  Newsreader610463
//
//  Created by Vicente on 22/10/2020.
//

import SwiftUI

struct HomepageView: View {
    
    @ObservedObject var newsReaderApi = NewsReaderAPI.shared
    @ObservedObject var articlesViewModel: ArticlesViewModel = ArticlesViewModel()
    
    var body: some View {
        
        NavigationView{
            VStack{
                if articlesViewModel.articles != nil && articlesViewModel.isLoading == false {
                    
                    if(articlesViewModel.articles!.count > 0){
                        ArticlesListView(articlesViewModel: self.articlesViewModel)
                    }else{
                        VStack(){
                            Text("articles_not_found")
                            Button(action: { self.articlesViewModel.refresh() }, label: {
                                Text("refresh")
                            })
                        }.padding()
                    }
                    
                } else {
                    ProgressView("loading_articles")
                        .onAppear {
                            self.articlesViewModel.fetchArticles()
                        }
                }
            }.navigationTitle("latest_articles").navigationBarItems(leading: HStack{
                if newsReaderApi.isAuthenticated{
                    
                    NavigationLink(destination: ProfileView(), label: {
                        Image(systemName: "person")
                    })
                    
                    Button(action: { self.articlesViewModel.refresh() }, label: {
                        Text("refresh")
                    }).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)).frame(maxWidth: .infinity)
                } else {
                    NavigationLink(destination: LoginView(), label: { Text("log_in") })
                }
            }, trailing: HStack{
                if newsReaderApi.isAuthenticated{
                    NavigationLink(
                        destination: FavoritesView(),
                        label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }).frame(maxWidth: .infinity)
                } else {
                    NavigationLink(destination: RegisterView(), label: { Text("register") })
                }
            })
        }
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
