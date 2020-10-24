//
//  UrlImage.swift
//  Newsreader610463
//
//  Created by Vicente on 19/10/2020.
//

import Foundation
import SwiftUI

class UrlImage: ObservableObject {
    @Published var image: UIImage?
    var url: URL?
    var imageCache = ImageCache.getImageCache()
    
    init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard let url = url else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: url.absoluteString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            
            self.imageCache.set(forKey: self.url!.absoluteString, image: loadedImage)
            self.image = loadedImage
        }
    }
}
