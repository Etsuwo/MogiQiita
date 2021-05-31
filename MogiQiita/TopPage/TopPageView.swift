//
//  ContentView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/22.
//

import SwiftUI

struct TopPageView: View {
    @State private var showingModal = false
    @State private var showingErrorAlert = false
    @State private var enterWithNoAccessToken = false
    @ObservedObject private var userInfo = UserInfo.shared
    
    var body: some View {
        ZStack {
            Image("topBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack() {
                    Text("Qiita Feed App")
                        .font(.custom("Pacifico", size: 36))
                        .foregroundColor(Color.white)
                    
                    Text("-PlayGround-")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.4)
                    
                    Button(action: {
                        self.showingModal.toggle()
                    }, label: {
                        Text("ログイン")
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * 0.8, height: 50, alignment: .center)
                            .background(Color(#colorLiteral(red: 0.2745098039, green: 0.5137254902, blue: 0, alpha: 1)))
                            .cornerRadius(25)
                    })
                    .sheet(isPresented: $showingModal, content: {
                        WebView(showingModal: $showingModal, showingErrorAlert: $showingErrorAlert, transitionFeedPage: $userInfo.isAccessTokenSet, url: AuthorizeRequest().URL)
                    })
                    .alert(isPresented: $showingErrorAlert, content: {
                        Alert(title: Text("認証エラー"))
                    })
                    .padding()
                    
                    //iOS14.4以下では複数のsheetやfullScreenCoverを同一ビュー階層内で複数適用できない
                    EmptyView()
                        .fullScreenCover(isPresented: $userInfo.isAccessTokenSet, content: {
                            FeedPageView()
                        })
                    
                    Button(action: {
                        enterWithNoAccessToken.toggle()
                    }, label: {
                        Text("ログインせずに利用する")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    })
                    .fullScreenCover(isPresented: $enterWithNoAccessToken, content: {
                        FeedPageView()
                    })
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TopPageView()
                .previewDevice("iPhone 8")
        }
    }
}
