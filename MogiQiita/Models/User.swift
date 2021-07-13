//
//  User.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/08.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String
    var profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL = "profile_image_url"
    }
}

extension User {
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try value.decode(String.self, forKey: .id)
        name = try value.decode(String.self, forKey: .name)
        profileImageURL = try value.decode(String.self, forKey: .profileImageURL)
    }
}
