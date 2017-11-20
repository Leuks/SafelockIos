//
//  Password.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 16/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit
import Fuse

class Password : Fuseable {
    var index: Int!
    @objc dynamic var username: String!
    @objc dynamic var website: String!
    @objc dynamic var password: String!

    var properties: [FuseProperty] {
        return [
            FuseProperty(name: "website", weight: 1)
        ]
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
}
