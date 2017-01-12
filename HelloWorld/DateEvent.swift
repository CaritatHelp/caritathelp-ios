//
//  DateEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 15/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class DateCreateEvent : UIViewController {
    
    @IBOutlet weak var DisplayStart: UILabel!
    @IBOutlet weak var DisplayEnd: UILabel!
    @IBOutlet weak var DateStart: UIDatePicker!
    @IBOutlet weak var DateEnd: UIDatePicker!
    
    var start = ""
    var end = ""
    var eventTitle = ""
    var city = ""
    var descp = ""
    var state = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayStart.text = start
        DisplayEnd.text = end
        
    }

    
    @IBAction func getDateStart(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: DateStart.date)
        DisplayStart.text = "Début : " + strDate
        start = strDate
    }
    
    @IBAction func getDateEnd(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: DateEnd.date)
        DisplayEnd.text = "Fin : " + strDate
        end = strDate
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool {
        
        if (identifier == "BackToMenuVC") {
            
            if (DisplayStart.text!.isEmpty) {
                SCLAlertView().showError("Attention", subTitle: "veuillez donner une date de début à votre évènement")
                return false
            }
            else {
                return true
            }

        }
        else {
            return false
        }

    }
    
    func viewWillDisappear(animated: Bool) {
        print("avant d'envoyer les data.....")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let StarDate = dateFormatter.string(from: DateStart.date)
        let EndDate = dateFormatter.string(from: DateEnd.date)
        let myVC = storyboard!.instantiateViewController(withIdentifier: "CreateEventVC") as! MenuOwnerAssocation
        
        myVC.EventDateStart = StarDate
        myVC.EventDateEnd = EndDate
        
        
    }
}
