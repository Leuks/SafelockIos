//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit
import Fuse

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    let fuse = Fuse()
    var passwords = [Password]()
    var filteredPasswords = [Password]()
    var filteredPasswordsWebsites = [NSAttributedString]()
    var editingPassword:Password? = nil
    var editingIndex: Int? = nil

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
            if editingPassword != nil {
                let editIndexPath = IndexPath(row: editingIndex!, section: 0)

                passwords[editIndexPath.row] = password
                passwordsTableView.reloadRows(at: [editIndexPath], with: .automatic)

                editingPassword = nil
                editingIndex = nil
            } else {
                let newIndexPath = IndexPath(row: passwords.count, section: 0)

                password.index = passwords.count

                passwords += [password]
                passwordsTableView.insertRows(at: [newIndexPath], with: .automatic)
            }

            savePasswords()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        let vc = segue.destination as! UINavigationController

        guard vc.childViewControllers.count > 0 else {
            return
        }

        let addWebsite = vc.childViewControllers[0] as! AddWebsiteController

        addWebsite.password = self.editingPassword
    }

    //MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPasswordsWebsites.count
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
            item = filteredPasswordsWebsites[indexPath.row]
        } else {
            item = NSAttributedString(string: passwords[indexPath.row].website)
        }

        cell.websiteLabel.attributedText = item
        cell.usernameLabel.text = passwords[indexPath.row].username
        cell.loadImage()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let actionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        var targetArray = (searchController.isActive && searchController.searchBar.text != "") ? filteredPasswords : passwords

        actionMenu.title = targetArray[indexPath.row].website

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            actionMenu.dismiss(animated: true, completion: nil)
            let confirm = ConfirmDeletion.init(title: "Confirm deletion", message: actionMenu.title! + " will be deleted", confirm: {
                () -> Void in
                self.removePassword(index: targetArray[indexPath.row].index)
                self.updateSearchResults(for: self.searchController)
                self.savePasswords()
            })

            self.present(confirm.alert!, animated: true, completion: nil)
        })

        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (_: UIAlertAction!) -> Void in
            self.editingPassword = targetArray[indexPath.row]
            self.editingIndex = indexPath.row

            self.performSegue(withIdentifier: "ShowAddWebsite", sender: self)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            actionMenu.dismiss(animated: true, completion: nil)
        })

        actionMenu.addAction(deleteAction)
        actionMenu.addAction(editAction)
        actionMenu.addAction(cancelAction)

        present(actionMenu, animated: true, completion: nil)
    }

    //MARK : SearchDelegate

    func updateSearchResults(for searchController: UISearchController) {
        let boldAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.init(red: 0.926, green: 0.655, blue: 0.239, alpha: 1)
        ]

        let searchStr = searchController.searchBar.text ?? ""
        let results = fuse.search(searchStr, in: passwords)

        filteredPasswordsWebsites = results.map { (index: Int, _, matchedRanges) in
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

        filteredPasswords = results.map { (index: Int, _, matchedRanges) in return passwords[index] }

        passwordsTableView.reloadData()
    }

    //MARK: Private methods

    private func loadPasswords() {
        let storedPasswords = User.current()?.passwords

        if (storedPasswords != nil) {
            passwords += storedPasswords!
        }
    }

    private func removePassword(index: Int) {
        passwords = passwords.filter({ (password: Password) -> Bool in return password.index != index })
    }

    private func savePasswords() {
        User.current()?.passwords = passwords

        User.saveAll()
    }
}

