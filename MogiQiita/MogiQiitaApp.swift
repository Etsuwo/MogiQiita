//
//  MogiQiitaApp.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/22.
//

import SwiftUI
import KeychainAccess

@main
struct MogiQiitaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            TopPageView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        readEnv()
        obtainAccessTokenFromKeychain()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if UserInfo.shared.isLogin {
            resisterAccessTokenToKeychain()
        }
    }
    
    func readEnv() {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
                    fatalError("Not found: './.env'. Please create .env file")
                }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let str = String(data: data, encoding: .utf8) ?? "Empty File"
            let clean = str.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "'", with: "")
            let envVars = clean.components(separatedBy:"\n")
            for envVar in envVars {
                let keyVal = envVar.components(separatedBy:"=")
                if keyVal.count == 2 {
                    setenv(keyVal[0], keyVal[1], 1)
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func obtainAccessTokenFromKeychain() {
        let keychain = Keychain(service: "com.gmail.324etsushi.MogiQiita")
        guard let token = try? keychain.get("accessToken") else {
            print("##### Cannot obtain access token from keycain ######")
            return
        }
        print("##### success obtain access token from keychain #####")
        print("token: " + token)
        UserInfo.shared.accessToken = token
        UserInfo.shared.isLogin = true
    }
    
    func resisterAccessTokenToKeychain() {
        let keychain = Keychain(service: "com.gmail.324etsushi.MogiQiita")
        do {
            try keychain.set(UserInfo.shared.accessToken, key: "accessToken")
        } catch {
            print("##### failed to resister access token #####")
        }
    }
}
