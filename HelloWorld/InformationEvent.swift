//
//  InformationEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 17/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class InformationsEvent: UIViewController {
    
    var Event : JSON = []
    
        //variable en lien avec la storyBoard
    @IBOutlet weak var DescEvent: UITextView!
    @IBOutlet weak var DateEvent: UILabel!
    @IBOutlet weak var LieuEvent: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DescEvent.text! = String(describing: Event["description"])
        DateEvent.text! = "Début : " + String(describing: Event["begin"]) + "\nFin : " + String(describing: Event["end"])
        LieuEvent.text! = String(describing: Event["place"])
        
    }
}
