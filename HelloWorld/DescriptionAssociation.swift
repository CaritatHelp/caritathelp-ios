//
//  DescriptionAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 24/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DescriptionAssociation : UIViewController {
    //var user : JSON = []
    var Asso : JSON = []
    
    
    @IBOutlet weak var NameAsso: UILabel!
    @IBOutlet weak var descriptionText: UILabel!

    @IBOutlet weak var LieuAsso: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameAsso.text! = String(describing: Asso["response"]["name"])
        descriptionText.text! = String(describing: Asso["response"]["description"])
        LieuAsso.text! = String(describing: Asso["response"]["city"])
    }
}
