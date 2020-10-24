//
//  ContentView.swift
//  Newsreader610463
//
//  Created by Vicente on 11/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var newsReaderApi = NewsReaderAPI.shared
    
    var body: some View {
        NavigationView{
            
            if newsReaderApi.isAuthenticated{
                VStack {
                    HomepageView()
                }.navigationTitle("News Reader")
                .navigationBarItems(leading: Button(action: { newsReaderApi.logout() }, label: {
                    Image(systemName: "escape")
                }),
                trailing: NavigationLink(
                    destination: FavoritesView(),
                    label: {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }))
            } else {
                VStack {
                    HomepageView()
                }.navigationTitle("News Reader")
                .navigationBarItems(trailing: NavigationLink(
                    destination: LoginView(),
                    label: {
                        Text("Log in")
                    }
                ))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
