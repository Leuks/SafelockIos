//
//  PasswordTableViewCell.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 18/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: public
    func loadImage() {
        let url = "https://logo.clearbit.com/" + (websiteLabel.text)! + "?size=450"

        logoImageView.downloadedFrom(link: url)
    }

}
