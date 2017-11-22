//
//  Password.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 16/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

struct UserPropertyKey {
    static let username = "username"
    static let password = "password"
}

class User : NSObject, NSCoding {
    var username: String!
    var password: String!

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users")

    init?(username: String!, password: String!) {
        guard !username.isEmpty else {
            return nil
        }

        guard !password.isEmpty else {
            return nil
        }

        self.username = username
        self.password = password
    }

    //MARK: NSCoding

    func encode(with aCoder: NSCoder) {
        print("encode", index)
        aCoder.encode(username, forKey: UserPropertyKey.username)
        aCoder.encode(password, forKey: UserPropertyKey.password)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObject(forKey: UserPropertyKey.username) as? String else {
            return nil
        }

        guard let password = aDecoder.decodeObject(forKey: UserPropertyKey.password) as? String else {
            return nil
        }

        self.init(username: username, password: password)
    }

}

