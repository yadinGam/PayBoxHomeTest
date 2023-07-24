//
//  AlertableProtocol.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit

protocol Alertable {
    func presentAlert(title: String?, message: String, buttonTitle: String?)
    func presentAlert(title: String?, message: String, actions: [UIAlertAction]?)
}

extension Alertable where Self: UIViewController {
    
    func presentAlert(title: String? = nil, message: String, buttonTitle: String? = "OK") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) {  (action) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func presentAlert(title: String? = nil, message: String, actions: [UIAlertAction]?) {
        if let actions = actions {
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            actions.forEach( { alertController.addAction($0) } )
            self.present(alertController, animated: true)
        } else {
            presentAlert(title: title, message: message, buttonTitle: "OK")
        }
    }
    
}
