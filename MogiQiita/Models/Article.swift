//
//  Article.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/08.
//

import Foundation

struct Article: Codable {
    var id: String
    var createdAt: Date
    var title: String
    var url: String
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case title
        case url
        case user
    }
}

extension Article {
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try value.decode(String.self, forKey: .id)
        createdAt = try value.decode(Date.self, forKey: .createdAt)
        title = try value.decode(String.self, forKey: .title)
        url = try value.decode(String.self, forKey: .url)
        user = try value.decode(User.self, forKey: .user)
    }
    
    
}
