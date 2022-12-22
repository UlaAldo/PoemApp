//
//  AlertController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 11/07/22.
//

import UIKit

extension UIAlertController {
    
    func showAlert(from: UIViewController,_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        from.present(alert, animated: true, completion: nil)
        alert.addAction(okAction)
    }
}
