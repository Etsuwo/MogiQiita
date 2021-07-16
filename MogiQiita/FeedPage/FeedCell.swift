//
//  FeedCell.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/08.
//

import SwiftUI

struct FeedCell: View {
    var info: FeedCellInfo
        
    var body: some View {
        HStack {
            URLImageView(imageLoader: URLImageLoader(url: info.userImageURL))
                .frame(width: 38, height: 38, alignment: .center)
                .clipShape(Circle())
                
            VStack(alignment: .leading) {
                Text(info.title)
                    .lineLimit(2)
                HStack {
                    Text("@\(info.userID) 投稿日: \(info.createdAt)")
                }
                .lineLimit(1)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}
/*
struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell(info: FeedCellInfo(article: Article(id: "hogehoge", createdAt: Date(), title: "hogehoge", url: "hogehoge", user: User(id: "hogehoge", name: "hogehoge"))))
        
    }
}
*/
