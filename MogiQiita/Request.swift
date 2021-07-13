//
//  Request.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/05/27.
//

import Foundation
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
                UserInfo.shared.isAccessTokenSet = true
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        })
    }
}

struct ArticleRequest {
    private let path = "/items"
    private var url: String {
        return APIEndPoint.baseURL + path
    }
    private let method: HTTPMethod = .get
    private var header: HTTPHeaders {
            return [
                .authorization(bearerToken: UserInfo.shared.accessToken),
                .contentType("application/json")]
    }
    private let parameters: [String: Any] = ["page": 1, "per_page": 100]
    
    func exec(completion: @escaping (_ result: Result<Any, Error>) -> ()){
        AF.request(self.url, method: self.method, parameters: self.parameters, encoding: URLEncoding.default, headers: self.header).response(completionHandler: { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("##### failed to Article request #####")
                    return
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let articles = try? decoder.decode([Article].self, from: data)
                completion(.success(articles ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
