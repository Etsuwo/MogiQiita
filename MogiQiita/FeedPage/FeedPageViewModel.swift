//
//  FeedPageViewModel.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/08.
//

import SwiftUI
import Combine
import Alamofire

class FeedPageViewModel: ObservableObject {
    @Published var cellInfo: [FeedCellInfo] = []
    @Published var searchText: String = ""
    @Published var isRefresh: Bool = false
    private(set) var apiLoadingStatus: APILoadingStatus = .initial
    private var nextPage = 1
    private var request: DataRequest?
    var pageNationIndex: Int {
        if cellInfo.count > 10 {
            return cellInfo.count - 10
        }
        return 0
    }
    
    init() {
        fetchArticle()
    }
    
    func fetchArticle() {
        if apiLoadingStatus == .fetching || apiLoadingStatus == .full {
            return
        }
        apiLoadingStatus = .fetching
        request = ArticleRequest().exec(page: nextPage, searchText: searchText, completion: { result in
            switch result {
            case .success(let data):
                guard let articlesData = data as? [Article] else {
                    return
                }
                if articlesData.isEmpty {
                    if self.cellInfo.isEmpty {
                        self.apiLoadingStatus = .none
                    } else {
                        self.apiLoadingStatus = .full
                    }
                } else {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .none
                    formatter.locale = Locale(identifier: "ja_JP")
                    self.cellInfo.append(contentsOf: articlesData.map { article in
                        return FeedCellInfo(article: article)
                    })
                    self.apiLoadingStatus = .loadMore
                    self.nextPage += 1
                }
                self.isRefresh = false
                
            case .failure(let error):
                self.apiLoadingStatus = .error
                print(error)
            }
        })
    }
    
    func reloadList() {
        request?.cancel()
        cellInfo = []
        nextPage = 1
        apiLoadingStatus = .initial
        fetchArticle()
    }
}

struct FeedCellInfo: Hashable, Identifiable {
    var id: String
    var createdAt: String
    var title: String
    var url: String
    var userID: String
    var userImageURL: String
    
    init(article: Article) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        id = article.id
        createdAt = formatter.string(from: article.createdAt)
        title = article.title
        url = article.url
        userID = article.user.id
        userImageURL = article.user.profileImageURL
    }
}
