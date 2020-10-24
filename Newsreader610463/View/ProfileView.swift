//
//  ProfileView.swift
//  Newsreader610463
//
//  Created by Vicente on 24/10/2020.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var newsReaderApi = NewsReaderAPI.shared
    @ObservedObject var userSettings = UserSettings.shared
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack{
            if !newsReaderApi.isAuthenticated {
                Text("Login first.")
                Button("Go back", action:{
                    self.presentationMode.wrappedValue.dismiss()
                })
            }else{
                
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                
                VStack{
                    Text("logged_in_as")
                    Text(" \(userSettings.username ?? "user")")
                }

                VStack {
                    Button(action: {
                        if(userSettings.lang == "en"){
                            userSettings.prefLang = "es"
                        }else{
                            userSettings.prefLang = "en"
                        }
                    }) {
                        Text("switch_language")
                    }.padding()
                 }
                
                Button(action:{
                    newsReaderApi.logout()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    SwiftUI.Text("logout")
                        .frame(maxWidth: 250, minHeight: 44)
                        .foregroundColor(.white)
                }).background(Color.blue).cornerRadius(8.0).padding()
                
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
