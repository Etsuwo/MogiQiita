//
//  TabbarView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/06/01.
//

import SwiftUI

struct TabbarView: View {
    @State private var selection = "Feed"
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.white
    }
    
    var body: some View {
        VStack {
            Text(selection)
                .font(.custom("Pacifico", size: 17))
            
            TabView(selection: $selection) {
                FeedPageView()
                    .tabItem {
                        Image("Feed")
                        Text("フィード")
                    }
                    .tag("Feed")
                TagPageView()
                    .tabItem {
                        Image("Tag")
                        Text("タグ")
                    }
                    .tag("Tags")
                MyPageView()
                    .tabItem {
                        Image("Mypage")
                        Text("マイページ")
                    }
                    .tag("MyPage")
                SettingPageView()
                    .tabItem {
                        Image("Setting")
                        Text("設定")
                    }
                    .tag("Settings")
            }
            .accentColor(Color(#colorLiteral(red: 0.4549019608, green: 0.7568627451, blue: 0.2274509804, alpha: 1)))
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
