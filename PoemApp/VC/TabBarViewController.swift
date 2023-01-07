//
//  TabBarViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 26/06/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsIcon()
    }
    
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            self.tabBar.layer.masksToBounds = true
            self.tabBar.isTranslucent = true
            self.tabBar.barStyle = .default
            self.tabBar.layer.cornerRadius = 20
            self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        }
    
    private func setColorsIcon() {
        let appearance = UITabBarAppearance()
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 156/255,
                                                                      green: 171/255,
                                                                      blue: 160/255,
                                                                      alpha: 1)
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                                            UIColor(red: 156/255,
                                                                                    green: 171/255,
                                                                                    blue: 160/255,
                                                                                    alpha: 1)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                                            UIColor.white
        ]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        self.tabBar.standardAppearance = appearance
    
    }

}

