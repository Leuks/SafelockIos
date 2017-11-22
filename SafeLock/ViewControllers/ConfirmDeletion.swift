//
//  ConfirmDeletion.swift
//  SafeLock
//
//  Created by Gabriel Juchault on 20/11/2017.
//  Copyright © 2017 Juchault.Lemarié. All rights reserved.
//

import UIKit

class ConfirmDeletion {
    var alert: UIAlertController? = nil

    init(title: String, message: String, confirm: @escaping () -> Void) {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert?.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            confirm()
        }))

        alert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.alert?.dismiss(animated: true, completion: nil)
        }))
    }
}
