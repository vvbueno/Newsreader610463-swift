//
//  ContentView.swift
//  Newsreader610463
//
//  Created by Vicente on 11/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var newsReaderApi = NewsReaderAPI.shared
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
        HomepageView().environment(\.locale, .init(identifier: userSettings.lang))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
