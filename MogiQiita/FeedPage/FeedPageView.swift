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
            
            List {
                ForEach(viewModel.cellInfo, id: \.self, content: { info in
                    FeedCell(info: info)
                        .onAppear(perform: {
                            if viewModel.cellInfo[viewModel.pageNationIndex].id == info.id {
                                viewModel.fetchArticle()
                            }
                        })
                })
            }
            .pullToRefresh(isShowing: $viewModel.isRefresh, onRefresh: {
                viewModel.reloadList()
            })
        }
    }
}

struct FeedPageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPageView()
    }
}
