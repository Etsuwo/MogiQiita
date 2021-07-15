//
//  FeedPageView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/28.
//

import SwiftUI

struct FeedPageView: View {
    @State var searchText: String = ""
    @StateObject var viewModel = FeedPageViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                TextField("Search", text: $searchText)
                    .padding(.vertical, 8)
            }
            .background(Color(#colorLiteral(red: 0.9384178519, green: 0.9356803298, blue: 0.9419459105, alpha: 1)))
            .cornerRadius(8)
            .padding(.horizontal)
            
            List {
                ForEach(viewModel.cellInfo, id: \.id, content: { info in
                    FeedCell(info: info)
                        .onAppear(perform: {
                            if viewModel.cellInfo[viewModel.pageNationIndex].id == info.id {
                                viewModel.fetchArticle()
                            }
                        })
                })
            }
        }
    }
}

struct FeedPageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPageView()
    }
}
