//
//  AlertController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 11/07/22.
//

import UIKit

extension UIAlertController {
    
    func showAlert(fromController: UIViewController) {
        let alert = UIAlertController(title: "Empty input!", message: "write the word", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        fromController.present(alert, animated: true, completion: nil)
        alert.addAction(okAction)
    }
}
