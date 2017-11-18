//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class MainController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    var passwords = [Password]()

    @IBOutlet weak var passwordsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //passwordsTableView.register(PasswordTableViewCell.self, forCellReuseIdentifier: "PasswordTableViewCell")

        passwordsTableView.dataSource = self
        passwordsTableView.delegate = self

        loadPasswords()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Navigation

    @IBAction func saveEntry(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddWebsiteController, let password = sourceViewController.password {
            passwords += [password]
        }
    }

    //MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PasswordTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PasswordTableViewCell else {
            fatalError("The dequeued cell is not an instance of PasswordTableViewCell.")
        }

        let password = passwords[indexPath.row]

        print(password.website)

        cell.websiteLabel.text = password.website
        cell.usernameLabel.text = password.username

        return cell
    }

    //MARK: Private methods

    private func loadPasswords() {
        let password = Password.init(username: "johndoe", website: "google.fr", password: "foobar")

        passwords += [password!]
    }
}

