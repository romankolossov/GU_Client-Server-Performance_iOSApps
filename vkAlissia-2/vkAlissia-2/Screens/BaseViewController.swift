//
//  BaseViewController.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 02.09.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   handler: ((UIAlertAction) -> ())? = nil,
                   completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}
