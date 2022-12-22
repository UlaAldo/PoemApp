//
//  Spinner.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 22/12/22.
//

import Foundation
import UIKit

open class Spinner {
    
    internal static var spinner: UIActivityIndicatorView?
    
    public static var style: UIActivityIndicatorView.Style = .whiteLarge
    //public static var baseBackColor = UIColor.lightGray.withAlphaComponent(0.5)
    public static var baseColor = UIColor.lightGray
    
    public static func start(style: UIActivityIndicatorView.Style = style, baseColor: UIColor = baseColor) {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            //spinner!.backgroundColor = backColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
    
    @objc public static func update() {
        if spinner != nil {
            stop()
            start()
        }
    }
}
