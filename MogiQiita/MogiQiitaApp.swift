//
//  MogiQiitaApp.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/22.
//

import SwiftUI

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
        return true
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
}
