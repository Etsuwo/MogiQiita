//
//  URLImageView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/13.
//

import SwiftUI

struct URLImageView: View {
    
    @ObservedObject var imageLoader: URLImageLoader
    
    var body: some View {
        if let image = imageLoader.image {
            return image.resizable()
        } else {
            return Image(systemName: "person.circle.fill").resizable()
        }
    }
}

struct URLImageView_Previews: PreviewProvider {
    static var previews: some View {
        URLImageView(imageLoader: URLImageLoader(url: "hogehoge"))
    }
}

class URLImageLoader: ObservableObject {
    @Published var image: Image?
    static let ImageCache = NSCache<AnyObject, UIImage>()
    
    init(url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        if let cachedImage = URLImageLoader.ImageCache.object(forKey: imageURL as AnyObject) {
            print("####### from cached !!!!!!!!!! #########")
            DispatchQueue.main.async {
                self.image = Image(uiImage: cachedImage)
            }
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: imageURL),
                      let uiImage = UIImage(data: data) else {
                    return
                }
                URLImageLoader.ImageCache.setObject(uiImage, forKey: imageURL as AnyObject)
                print("####### cached Image ##########")
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            }
        }
    }
}
