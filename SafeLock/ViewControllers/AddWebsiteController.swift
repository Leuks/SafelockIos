//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class AddWebsiteController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!

    var password: Password?

    override func viewDidLoad() {
        super.viewDidLoad()

        websiteTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        if password != nil {
            websiteTextField.text = password?.website
            usernameTextField.text = password?.username
            passwordTextField.text = password?.password
        }

        updateSaveButtonState()
    }

    func viewWillAppear() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }

        password = Password.init(index: -1, username: usernameTextField.text, website: websiteTextField.text, password: passwordTextField.text)
        password?.image = logoImageView.image
    }

    //MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateSaveButtonState()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()

        if (!(websiteTextField.text?.isEmpty)!) {
            let urlStr = "https://logo.clearbit.com/" + (websiteTextField.text)! + "?size=450"

            logoImageView.downloadedFrom(url: URL(string: urlStr)!)
        }

        guard textField == websiteTextField else {
            return
        }

        guard !(textField.text?.isEmpty)! else {
            navigationItem.title = "Add a website"
            return
        }

        navigationItem.title = textField.text
    }

    //MARK: Actions

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Private methods

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let website = websiteTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        saveButton.isEnabled = !website.isEmpty && !username.isEmpty && !password.isEmpty
    }
}
