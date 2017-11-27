//
//  String+toRedNumbers.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 27/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toRedNumbers() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)

        let menloAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Menlo-Bold", size: 18.0)
        ]

        attributedString.addAttributes(menloAttributes, range: NSRange(location: 0, length: self.count))

        let redAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.init(red: 0.926, green: 0.655, blue: 0.239, alpha: 1)
        ]

        var i = 0
        self.characters.forEach { (c: Character) in
            if c >= "0" && c <= "9" {
                let range = NSRange(location: i, length: 1)
                attributedString.addAttributes(redAttributes, range: range)
            }

            i = i + 1
        }

        return attributedString
    }
}
