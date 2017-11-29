//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        User.loadAll()
    }

    func viewWillAppear() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc private func login(_ button: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text

        guard !(username?.isEmpty)! || !(password?.isEmpty)! else {
            print("refused because of field")
            errorTextField.text = "Invalid login"
            return
        }

        let user = User.all().first(where: { (user: User) -> Bool in return user.username == username })
        let users = User.all()

        guard user != nil else {
            print("refused because of not found user")
            errorTextField.text = "Invalid login"
            return
        }

        guard user!.login(pwd: password!) else {
            print("refused because of login")
            errorTextField.text = "Invalid login"
            return
        }

        self.performSegue(withIdentifier: "LoginSuccessful", sender: self)
    }
}


