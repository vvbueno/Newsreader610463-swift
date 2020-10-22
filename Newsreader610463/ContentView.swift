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
                    ArticlesListView()
                }.navigationTitle("News Reader")
                .navigationBarItems(leading: Button(action: { newsReaderApi.logout() }, label: {
                    Image(systemName: "escape")
                }),
                trailing: NavigationLink(
                    destination: Text("Favorite Articles"),
                    label: {
                        Image(systemName: "star")
                    }))
            } else {
                VStack {
                    ArticlesListView()
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
