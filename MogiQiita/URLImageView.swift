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
    
    init(url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageURL) else {
                return
            }
            DispatchQueue.main.async {
                guard let uiImage = UIImage(data: data) else {
                    return
                }
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}
