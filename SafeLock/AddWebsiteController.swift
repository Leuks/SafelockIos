//
//  ViewController.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 15/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class AddWebsiteController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func viewWillAppear() {
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.title = "Back";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("save button")
    }
}
