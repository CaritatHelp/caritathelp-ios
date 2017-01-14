//
//  UIViewController+Caritathelp.swift
//  Caritathelp
//
//  Created by Jeremy gros on 14/01/2017.
//  Copyright © 2017 Jeremy gros. All rights reserved.
//

import UIKit

extension UIViewController {
    func gradientBackground() -> CAGradientLayer {
        let colorBottom =  UIColor(red: 250.0/255.0, green: 255.0/255.0, blue: 209.0/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 161.0/255.0, green: 255.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        return gradientLayer
//        gradientLayer.frame = self.view.bounds
//        
//        self.view.layer.addSublayer(gradientLayer)
    }
}
