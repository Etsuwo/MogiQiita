//
//  FeedPageView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/28.
//

import SwiftUI
import SwiftUIRefresh

struct FeedPageView: View {
    @StateObject var viewModel = FeedPageViewModel()
    
    var body: some View {
        if viewModel.apiLoadingStatus == .error {
            ErrorView(viewModel: viewModel)
        } else {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    TextField("Search", text: $viewModel.searchText)
                        .padding(.vertical, 8)
                }
                .background(Color(#colorLiteral(red: 0.9384178519, green: 0.9356803298, blue: 0.9419459105, alpha: 1)))
                .cornerRadius(8)
                .padding(.horizontal)
                .onReceive(viewModel.$searchText.debounce(for: 0.3, scheduler: DispatchQueue.main), perform: { _ in
                    self.viewModel.reloadList()
                })
                if viewModel.apiLoadingStatus == .none {
                    Spacer()
                    Text("検索にマッチする記事はありませんでした")
                        .padding()
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    Text("検索条件を変えるなどして再度検索をしてください")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Spacer()
                } else {
                    List(viewModel.cellInfo) { info in
                        FeedCell(info: info)
                            .onAppear(perform: {
                                viewModel.pageNation(info: info)
                            })
                    }
                    .pullToRefresh(isShowing: $viewModel.isRefresh, onRefresh: {
                        viewModel.reloadList()
                    })
                }
            }
        }
    }
}

struct FeedPageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPageView()
    }
}
