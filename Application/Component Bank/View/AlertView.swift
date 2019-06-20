//
//  AlertView.swift
//  Component Bank
//
//  Created by Saransh Mittal on 20/06/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class AlertView {
    public static func showAlert(title: String, message: String, buttonLabel: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonLabel, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            viewController.present(alertController, animated: true)
        })
    }
}
