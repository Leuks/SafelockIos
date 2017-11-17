//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class MainController: UIViewController, UINavigationControllerDelegate {
    var passwords = [Password]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPasswords()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Navigation

    @IBAction func saveEntry(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddWebsiteController, password = sourceViewController.password {
            passwords.append(password)
        }
    }

    //MARK: Private methods
    private func loadPasswords() {
        let password = Password.init(username: "johndoe", website: "google.fr", password: "foobar")

        passwords.append(password!)
    }
}

