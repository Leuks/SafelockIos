//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit
import Fuse

class MainController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    let fuse = Fuse()
    var passwords = [Password]()
    var filteredPasswords = [NSAttributedString]()

    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var passwordsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup search contorller
        passwordsTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.autocorrectionType = UITextAutocorrectionType.no
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false


        // Setup delegates
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPasswords.count
        }

        return passwords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PasswordTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PasswordTableViewCell else {
            fatalError("The dequeued cell is not an instance of PasswordTableViewCell.")
        }

        var item: NSAttributedString

        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredPasswords[indexPath.row]
        } else {
            item = NSAttributedString(string: passwords[indexPath.row].website)
        }

        cell.websiteLabel.attributedText = item
        cell.usernameLabel.text = passwords[indexPath.row].username

        return cell
    }

    //MARK : SearchDelegate

    func updateSearchResults(for searchController: UISearchController) {
        let boldAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.init(red: 0.926, green: 0.655, blue: 0.239, alpha: 1)
        ]

        let searchStr = searchController.searchBar.text ?? ""
        let results = fuse.search(searchStr, in: passwords)

        filteredPasswords = results.map { (index: Int, _, matchedRanges) in
            let password = passwords[index]

            let attributedString = NSMutableAttributedString(string: password.website)
            matchedRanges
                .forEach {
                    $0.ranges.forEach {
                        let range = NSRange.init(Range.init($0))

                        attributedString.addAttributes(boldAttributes, range: range)
                    }
                }


            return attributedString
        }

        passwordsTableView.reloadData()
    }

    //MARK: Private methods

    private func loadPasswords() {
        let password = Password.init(username: "johndoe", website: "google.fr", password: "foobar")

        passwords += [password!]
    }
}

