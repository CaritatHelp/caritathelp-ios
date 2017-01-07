//
//  File.swift
//  Caritathelp
//
//  Created by Jeremy gros on 07/01/2017.
//  Copyright © 2017 Jeremy gros. All rights reserved.
//

import UIKit

class NoDataLabel: UILabel {
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ texte: String) {
        self.init(frame: CGRect(x: 0.0, y: 0.0,width: UIScreen.main.bounds.size.width, height: 50.0))
        
        self.text = texte
        self.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.textAlignment = NSTextAlignment.center
    }
}
