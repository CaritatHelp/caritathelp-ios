//
//  ViewCell.swift
//  Caritathelp
//
//  Created by Jeremy gros on 30/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class ViewCell : UIView {
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setData(imageName: String, nom: String){
        
    }
}