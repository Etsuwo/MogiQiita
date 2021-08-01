//
//  ErrorView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/27.
//

import SwiftUI

protocol ErrorViewModel {
    func reload()
}

struct ErrorView: View {
    
    var viewModel: ErrorViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Network")
                .resizable()
                .frame(width: 80, height: 80, alignment: .center)
            
            Text("ネットワークエラー")
                .font(.system(size: 14))
                .padding()
            
            Text("お手数ですが電波の良い場所で")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(1)
            
            Text("再度読み込みお願いします")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: {
                viewModel.reload()
            }, label: {
                Text("再読み込みする")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(#colorLiteral(red: 0.3358276784, green: 0.7716192603, blue: 0.008504265919, alpha: 1)))
                    .cornerRadius(25)
            })
        }
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(viewModel: FeedPageViewModel())
    }
}
