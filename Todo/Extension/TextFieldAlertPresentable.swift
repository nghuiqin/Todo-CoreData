//
//  TextFieldAlertPresentable.swift
//  Todo
//
//  Created by Ng Hui Qin on 5/5/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//

import Foundation

protocol TextFieldAlertPresentable where Self: UIViewController {
    func showTextFieldAlert(title: String, message: String, placeHolder: String, actionHandler: ((String) -> Void)?)
}

extension TextFieldAlertPresentable {
    /// Show TextField Alert Controller
    ///
    /// - Parameters:
    ///   - title: String Title
    ///   - message: String Message
    ///   - placeHolder: String TextField's placeholder
    ///   - in: UIViewController alert's parent
    ///   - actionHandler: ((String) -> Void)? TextField's content will be passed back
    func showTextFieldAlert(title: String, message: String, placeHolder: String, actionHandler: ((String) -> Void)?) {
        // Init alertController
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Set Ok action with handler
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            guard
                let textField = alertController.textFields?.first,
                let content = textField.text
                else {
                    actionHandler?("")
                    return
            }
            actionHandler?(content)
        }

        // Set Cancel action
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        // Add Text Field
        alertController.addTextField(configurationHandler: { $0.placeholder = placeHolder })

        // Add Buttons
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)

        // Present
        self.present(alertController, animated: true, completion: nil)
    }
}
