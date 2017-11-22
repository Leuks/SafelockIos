//
//  Password.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 16/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit
import Fuse

struct PasswordPropertyKey {
    static let index = "index"
    static let website = "website"
    static let username = "name"
    static let password = "password"
    static let image = "image"
}

class Password : NSObject, NSCoding, Fuseable {
    var index: Int!
    var image: UIImage?
    @objc dynamic var username: String!
    @objc dynamic var website: String!
    @objc dynamic var password: String!

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("passwords")

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

    //MARK: NSCoding

    func encode(with aCoder: NSCoder) {
        print("encode", index)
        aCoder.encode(index, forKey: PasswordPropertyKey.index)
        aCoder.encode(website, forKey: PasswordPropertyKey.website)
        aCoder.encode(username, forKey: PasswordPropertyKey.username)
        aCoder.encode(password, forKey: PasswordPropertyKey.password)
        aCoder.encode(image, forKey: PasswordPropertyKey.image)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let index = aDecoder.decodeObject(forKey: PasswordPropertyKey.index) as? Int else {
            return nil
        }

        guard let website = aDecoder.decodeObject(forKey: PasswordPropertyKey.website) as? String else {
            return nil
        }

        guard let username = aDecoder.decodeObject(forKey: PasswordPropertyKey.username) as? String else {
            return nil
        }

        guard let password = aDecoder.decodeObject(forKey: PasswordPropertyKey.password) as? String else {
            return nil
        }

        let image = aDecoder.decodeObject(forKey: PasswordPropertyKey.image) as? UIImage

        self.init(index: index, username: username, website: website, password: password)
        self.image = image
    }

}
