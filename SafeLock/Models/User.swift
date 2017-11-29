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
    static let iv = "iv"
}

class User : NSObject, NSCoding {
    var currentIndex: Int
    var username: String!
    var password: String!
    var clearPassword: String?
    var passwords = [Password]()
    var cipheredPasswords: Data!
    var iv: Data!

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
        self.iv = Data()
        self.cipheredPasswords = Data()
        self.currentIndex = 0
    }

    //MARK: public
    func login(pwd: String) -> Bool {
        guard password == pwd.sha512 else {
            print("refused because of pwd")
            return false
        }

        clearPassword = pwd

        print("set clear password to " + pwd)

        do {
            let deciphered = String(bytes: try cipheredPasswords.aes256Decrypt(withKey: clearPassword!, initializationVector: iv), encoding: .utf8)

            try deciphered?.components(separatedBy: "\n")
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

        if clearPassword == nil {
            aCoder.encode(cipheredPasswords, forKey: UserPropertyKey.cipheredPasswords)
            print("save other guy " + username)
            return
        }

        do {
            let iv = Data.generateInitializationVector()

            print("iv count")
            print(iv.count)

            let passwordsStringified = try passwords
                .map({
                    (password: Password) -> String in return (try String(data: JSONEncoder().encode(password), encoding: .utf8))!
                })
                .joined(separator: "\n")

            print(passwordsStringified)

            let cipher = try passwordsStringified
                .data(using: .utf8)!
                .aes256Encrypt(withKey: self.clearPassword!, initializationVector: iv)

            print(iv.count)

            aCoder.encode(iv, forKey: UserPropertyKey.iv)
            aCoder.encode(cipher, forKey: UserPropertyKey.cipheredPasswords)
        } catch {
            print(error)
        }

    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObject(forKey: UserPropertyKey.username) as? String else {
            print("no username")
            return nil
        }

        guard let password = aDecoder.decodeObject(forKey: UserPropertyKey.password) as? String else {
            print("no password")
            return nil
        }

        guard let ciphered = aDecoder.decodeObject(forKey: UserPropertyKey.cipheredPasswords) as? Data else {
            print("no cip")
            return nil
        }

        guard let iv = aDecoder.decodeObject(forKey: UserPropertyKey.iv) as? Data else {
            print("no iv")
            return nil
        }

        self.init(username: username, password: password)
        self.cipheredPasswords = ciphered
        self.iv = iv
    }

    //MARK: singleton

    static func loadAll() {
        let storedUsers = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
        print("got ")
        print(storedUsers?.count)

        if (storedUsers != nil) {
            users += storedUsers!
        }
    }

    static func all() -> [User] {
        return users
    }

    static func saveAll() {
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

