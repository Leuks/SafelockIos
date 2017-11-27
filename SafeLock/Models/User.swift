//
//  Password.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 16/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit
import Crypto

var currentUser: Int = -1
var users = [User]()

struct UserPropertyKey {
    static let username = "username"
    static let password = "password"
    static let cipheredPasswords = "cipheredPasswords"
}

class User : NSObject, NSCoding {
    var currentIndex: Int
    var username: String!
    var password: String!
    var clearPassword: String?
    var passwords = [Password]()
    var cipheredPasswords: String!

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
        self.cipheredPasswords = ""
        self.currentIndex = 0
    }

    //MARK: public
    func login(pwd: String) -> Bool {
        print(users)
        guard password == pwd.sha512 else {
            print("refused because of pwd")
            return false
        }

        clearPassword = pwd

        do {
            try cipheredPasswords.components(separatedBy: "\n")
                .forEach({ (line: String) in
                    let password = try JSONDecoder().decode(Password.self, from: line.data(using: .utf8)!)

                    self.passwords += [password]
                })
        } catch {
            print(error)
        }

        User.current(index: currentIndex)

        return true
    }

    //MARK: NSCoding

    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: UserPropertyKey.username)
        aCoder.encode(password, forKey: UserPropertyKey.password)

        if self.clearPassword == nil {
            aCoder.encode(cipheredPasswords, forKey: UserPropertyKey.cipheredPasswords)
            return
        }

        do {
            let passwordsStringified = try passwords
                .map({
                    (password: Password) -> String in return (try String(data: JSONEncoder().encode(password), encoding: .utf8))!
                })
                .joined(separator: "\n")

            print(passwordsStringified)

            aCoder.encode(passwordsStringified, forKey: UserPropertyKey.cipheredPasswords)
        } catch {
            print(error)
        }

    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObject(forKey: UserPropertyKey.username) as? String else {
            return nil
        }

        guard let password = aDecoder.decodeObject(forKey: UserPropertyKey.password) as? String else {
            return nil
        }

        guard let ciphered = aDecoder.decodeObject(forKey: UserPropertyKey.cipheredPasswords) as? String else {
            return nil
        }

        self.init(username: username, password: password)
        self.cipheredPasswords = ciphered
    }

    //MARK: singleton

    static func loadAll() {
        let storedUsers = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]

        if (storedUsers != nil) {
            users += storedUsers!
        }
    }

    static func all() -> [User] {
        return users
    }

    static func saveAll() {
        print(users)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(users, toFile: User.ArchiveURL.path)

        if (isSuccessfulSave) {
            print("saved users")
        } else {
            print("couldn't save users")
        }
    }

    static func current() -> User? {
        guard currentUser != -1 else {
            return nil
        }

        return users[currentUser]
    }

    static func current(index: Int) {
        currentUser = index
    }

    static func add(user: User) {
        user.currentIndex = users.count

        users += [user]
    }

}

