//
//  NavBar.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 26/06/22.
//

import Foundation
import UIKit


@objc protocol NavigationBarDelegate: AnyObject {
    @objc optional func leftAction()
    @objc optional func rightAction()
}

@IBDesignable
class NavigationBar: UIView {
    weak var delegate: NavigationBarDelegate?
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: NavigationBar.self)
        bundle.loadNibNamed("NavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        delegate?.leftAction?()
    }
    
    @IBAction func goNext(_ sender: UIButton) {
        delegate?.rightAction?()
    }
    
    
}
