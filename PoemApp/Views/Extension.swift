//
//  Extension.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 04/01/23.
//

import Foundation
import UIKit

extension UILabel {

    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                    
                }
            }
        }
    }

}
