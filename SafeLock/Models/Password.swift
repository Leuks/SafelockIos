//
//  Password.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 16/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit
import Fuse

final class Password : Codable, Fuseable {
    var index: Int!
    @objc dynamic var username: String!
    @objc dynamic var website: String!
    @objc dynamic var password: String!

    var properties: [FuseProperty] {
        return [
            FuseProperty(name: "website", weight: 1)
        ]
    }

    enum CodingKeys: String, CodingKey {
        case username
        case website
        case password
    }

    init?(index: Int!, username: String!, website: String!, password: String!) {
        guard !website.isEmpty else {
            return nil
        }

        guard !username.isEmpty else {
            return nil
        }

        guard !password.isEmpty else {
            return nil
        }

        self.index = index
        self.username = username
        self.website = website
        self.password = password
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decode(String.self, forKey: .username)
        website = try values.decode(String.self, forKey: .website)
        password = try values.decode(String.self, forKey: .password)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(website, forKey: .website)
        try container.encode(password, forKey: .password)
    }
}
