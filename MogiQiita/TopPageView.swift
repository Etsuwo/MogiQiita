//
//  ContentView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/22.
//

import SwiftUI

struct TopPageView: View {
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
                        //please write login action
                        
                    }, label: {
                        Text("ログイン")
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * 0.8, height: 50, alignment: .center)
                            .background(Color(#colorLiteral(red: 0.2745098039, green: 0.5137254902, blue: 0, alpha: 1)))
                            
                            .cornerRadius(25)
                        
                    })
                    .padding()
                    Button(action: {
                        //please write tapped action
                        
                    }, label: {
                        Text("ログインせずに利用する")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    })
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
        }
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
