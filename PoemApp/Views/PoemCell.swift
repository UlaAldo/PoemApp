//
//  PoemCell.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 28/06/22.
//

import UIKit

class PoemCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var starImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    
    func configure(with poem: Poem) {
        titleLabel.text = poem.headerPoem
        secondLabel.text = poem.textPoem
        dateLabel.text = poem.date
        
        if poem.star {
            starImage.image = UIImage(systemName: "star.fill")
            starImage.tintColor = UIColor(named: "Orange")
        } else {
            starImage.image = nil
        }

    }
   

}

