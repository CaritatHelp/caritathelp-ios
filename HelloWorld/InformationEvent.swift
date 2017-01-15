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
    var rights = ""
        //variable en lien avec la storyBoard
    @IBOutlet weak var DescEvent: UITextView!
    @IBOutlet weak var DateEvent: UILabel!
    @IBOutlet weak var LieuEvent: UILabel!
    
    
    @IBOutlet weak var showAnswerEmergencyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = String(describing: Event["title"])
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.GreenBasicCaritathelp()
        
        let start = String(describing: Event["begin"])
        let end = String(describing: Event["end"])
        DescEvent.text! = String(describing: Event["description"])
        DateEvent.text! = "Début : " + start.transformToDate() + " à " + start.getHeureFromString() + "\nFin : " + end.transformToDate() + " à " + end.getHeureFromString()
        LieuEvent.text! = String(describing: Event["place"])
        
        self.showAnswerEmergencyButton.isHidden = true
        if rights == "host" || rights == "admin" {
            self.showAnswerEmergencyButton.isHidden = false
        }
    }
    
    @IBAction func showAnswerEmergency(_ sender: Any) {
        let controller = AnswerEmergencyViewController()
        controller.eventID = String(describing: Event["id"])
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
