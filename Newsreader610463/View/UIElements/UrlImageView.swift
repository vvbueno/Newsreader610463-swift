//
//  UrlImageView.swift
//  Newsreader610463
//
//  Created by Vicente on 19/10/2020.
//

import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImage: UrlImage
    
    static var defaultImage = UIImage(named: "defaultNewsIcon")
    
    var width: CGFloat = 100
    var height: CGFloat = 100
        
    init(url: URL?, width: CGFloat, height: CGFloat) {
        self.urlImage = UrlImage(url: url)
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Image(uiImage: urlImage.image ?? UrlImageView.defaultImage!)
            .resizable()
            .scaledToFit()
            .frame(width: self.width, height: self.height)
    }
    

}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        UrlImageView(url: nil, width: 100, height: 100)
    }
}
