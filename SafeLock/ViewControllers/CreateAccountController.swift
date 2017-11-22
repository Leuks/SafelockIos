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
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordConfirmationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        updateSaveButtonState()
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

    //MARK: Actions

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Private methods

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmation = passwordConfirmationTextField.text ?? ""

        if (!password.isEmpty && !confirmation.isEmpty && confirmation != password) {
            errorLabel.text = "Les mots de passe ne correspondent pas"
        } else {
            errorLabel.text = ""
        }

        saveButton.isEnabled = !username.isEmpty && !password.isEmpty && !confirmation.isEmpty && confirmation == password
    }
}

