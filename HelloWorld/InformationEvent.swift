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
        print("----------------")
        print(Event["response"])
        print("---------------")
        DescEvent.text! = String(describing: Event["response"]["description"])
        DateEvent.text! = "Début : " + String(describing: Event["response"]["begin"]) + "\nFin : " + String(describing: Event["response"]["end"])
        LieuEvent.text! = String(describing: Event["response"]["place"])
        
    }
}
