//
//  WebView.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/27.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    @Binding var showingModal: Bool
    @Binding var showingErrorAlert: Bool
    @Binding var transitionFeedPage: Bool
    typealias UIViewType = WKWebView
    var url: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) ->
    UIViewType {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let url = URL(string: url) else {
            print(self.url)
            return
        }
        print(self.url)
        uiView.load(URLRequest(url: url))
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ webView: WebView) {
            parent = webView
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.request.url?.scheme == "mogiqiita",
               navigationAction.request.url?.host == "oauth-callback" {
                parent.showingModal.toggle()
                guard let URL = navigationAction.request.url?.absoluteString,
                      let code = NSURLComponents(string: URL)?.queryItems?[0].value else {
                    return
                }
                GetAccessTokenRequest().exec(code: code, completion: {result in
                    switch result {
                    case .success(_):
                        print("##### sucess #####")
                        print("access token : " + UserInfo.shared.accessToken)
                    case .failure(_):
                        self.parent.showingErrorAlert.toggle()
                    }
                })
            }
            decisionHandler(.allow)
        }
    }
}
