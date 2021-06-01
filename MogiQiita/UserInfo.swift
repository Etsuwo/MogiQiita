//
//  UserInfo.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/28.
//

import Foundation
import Combine

class UserInfo: ObservableObject {
    static let shared = UserInfo()
    private init() {}
    
    @Published var isAccessTokenSet: Bool = false
    var accessToken: String = ""
}
 
