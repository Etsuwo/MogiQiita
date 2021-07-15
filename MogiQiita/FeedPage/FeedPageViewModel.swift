//
//  FeedPageViewModel.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/08.
//

import SwiftUI
import Combine

class FeedPageViewModel: ObservableObject {
    @Published var cellInfo: [FeedCellInfo] = []
    private var apiLoadingStatus: APILoadingStatus = .initial
    private var nextPage = 1
    var pageNationIndex: Int {
        return cellInfo.count - 10
    }
    
    init() {
        print("##### called init #####")
        fetchArticle()
    }
    
    func fetchArticle() {
        if apiLoadingStatus == .fetching || apiLoadingStatus == .full {
            return
        }
        apiLoadingStatus = .fetching
        ArticleRequest().exec(page: nextPage, completion: { result in
            switch result {
            case .success(let data):
                guard let articlesData = data as? [Article] else {
                    return
                }
                if articlesData.isEmpty {
                    self.apiLoadingStatus = .full
                    return
                }
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                formatter.locale = Locale(identifier: "ja_JP")
                self.cellInfo.append(contentsOf: articlesData.map { article in
                    return FeedCellInfo(article: article)
                })
                self.apiLoadingStatus = .loadMore
                self.nextPage += 1
            case .failure(let error):
                self.apiLoadingStatus = .error
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
