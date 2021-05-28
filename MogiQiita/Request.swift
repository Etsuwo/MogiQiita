//
//  Request.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/27.
//

import Alamofire
import SwiftyJSON

class APIEndPoint: NSObject {
    static let baseURL = "https://qiita.com/api/v2/"
}

class ClientInfo: NSObject {
    static var id: String {
        guard let ID = ProcessInfo.processInfo.environment["QIITA_CLIENT_ID"] else {
            return ""
        }
        return ID
    }
    
    static var secret: String {
        guard let secret = ProcessInfo.processInfo.environment["QIITA_CLIENT_SECRET"] else {
            return ""
        }
        return secret
    }
}

struct AuthorizeRequest {
    private let path = "oauth/authorize?client_id="
    private let scope = "&scope=read_qiita+write_qiita"
    var URL: String {
        return APIEndPoint.baseURL + path + ClientInfo.id + scope
    }
}

struct GetAccessTokenRequest {
    private let header: HTTPHeaders = ["Content-Type":"application/json"]
    private let path = "access_tokens"
    private let method: HTTPMethod = .post
    
    func exec(code: String, completion: @escaping (_ result: Result<Any, Error>) -> ()) {
        let url = APIEndPoint.baseURL + path
        let parameters = ["client_id": ClientInfo.id, "client_secret": ClientInfo.secret, "code": code]
        print("##### exec() in GetAccessTokenRequest #####")
        print("URL: " + url)
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).response(completionHandler: { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                print("##### success exec() in GetAccessTokenRequest #####")
                print(json)
                UserInfo.shared.accessToken = json["token"].stringValue
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        })
    }
}
