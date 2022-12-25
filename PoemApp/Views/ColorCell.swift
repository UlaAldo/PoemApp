//
//  ColorCell.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 25/12/22.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    func transformToLarge ( ) {
        UIView.animate (withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1.5
        }
        let generator = UIImpactFeedbackGenerator (style: .light)
        generator.impactOccurred()
    }
    
    
    func transformToStandard() {
        UIView.animate (withDuration: 0.2) {
            self.layer.borderWidth = 0
            self.transform = CGAffineTransform.identity
        }
    }
}
