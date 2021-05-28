//
//  UserInfo.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/28.
//

import Foundation

class UserInfo {
    static let shared = UserInfo()
    private init() {}
    
    var accessToken: String = ""
}
 
