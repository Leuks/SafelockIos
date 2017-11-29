//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class CreateAccountController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!

    var users = [User]()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordConfirmationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(saveUser(_:)), for: .touchUpInside)

        updateSaveButtonState()
        loadUsers()
        print(users.count)
    }

    func viewWillAppear() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: UITextFieldDelegate

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }

    //MARK: Private methods

    private func loadUsers() {
        users = User.all()
    }

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmation = passwordConfirmationTextField.text ?? ""

        if (!username.isEmpty) {
            let hasUser = users.contains(where: { (user: User) -> Bool in user.username == username })

            if (hasUser) {
                errorLabel.text = "User already exists"
            }
        } else if (!password.isEmpty && !confirmation.isEmpty && confirmation != password) {
            errorLabel.text = "Passwords do not match"
        } else {
            errorLabel.text = ""
        }

        saveButton.isEnabled = !username.isEmpty && !password.isEmpty && !confirmation.isEmpty && confirmation == password
    }

    @objc private func saveUser(_ button: UIButton) {
        user = User.init(username: usernameTextField.text, password: passwordTextField.text?.sha512)

        User.add(user: user!)

        if (user?.login(pwd: passwordTextField.text!))! {
            print("register succeded")
            User.saveAll()
        }
    }
}

