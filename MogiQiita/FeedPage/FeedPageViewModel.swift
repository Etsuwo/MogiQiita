//
//  FeedPageViewModel.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/08.
//

import SwiftUI
import Combine

class FeedPageViewModel: ObservableObject {
    @Published var cellInfo: [FeedCellInfo]?
    
    func fetchArticle() {
        ArticleRequest().exec(completion: { result in
            switch result {
            case .success(let data):
                let articlesData = data as? [Article]
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                formatter.locale = Locale(identifier: "ja_JP")
                self.cellInfo = articlesData?.map { article in
                    return FeedCellInfo(article: article)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}

struct FeedCellInfo {
    var id: String
    var createdAt: String
    var title: String
    var url: String
    var user: User
    
    init(article: Article) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        id = article.id
        
        createdAt = formatter.string(from: article.createdAt)
        title = article.title
        url = article.url
        user = article.user
    }
}
