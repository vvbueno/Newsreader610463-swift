//
//  AritcleRowView.swift
//  Newsreader610463
//
//  Created by Vicente on 17/10/2020.
//

import SwiftUI

struct AritcleRowView: View {
    
    let article: Article
    
    @State var thumbnail: UIImage? = nil
    
    var body: some View {
        
        UrlImageView(url: article.image, width: 54, height: 54)
        
        VStack(alignment: .center){
            Text(article.title)
                .font(.title3)
        }

    }
}

/*
struct AritcleRowView_Previews: PreviewProvider {
    static var previews: some View {
        AritcleRowView()
    }
}
 */
