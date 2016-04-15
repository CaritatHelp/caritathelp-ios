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
    
    
    @IBOutlet weak var DescEvent: UITextView!
    @IBOutlet weak var DateEvent: UILabel!
    @IBOutlet weak var LieuEvent: UILabel!
    
    var Event : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("----------------")
        print(Event["response"])
        print("---------------")
        DescEvent.text! = String(Event["response"]["description"])
        DateEvent.text! = "Début : " + String(Event["response"]["begin"]) + "\nFin : " + String(Event["response"]["end"])
        LieuEvent.text! = String(Event["response"]["place"])
        
    }
}