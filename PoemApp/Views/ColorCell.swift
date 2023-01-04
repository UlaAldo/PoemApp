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
            self.layer.borderColor = UIColor(named: "Orange")!.cgColor
            self.layer.borderWidth = 1.3
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
