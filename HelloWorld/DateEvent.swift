//
//  DateEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 15/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayStart.text = start
        DisplayEnd.text = end
        
    }

    
    @IBAction func getDateStart(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(DateStart.date)
        DisplayStart.text = "Début : " + strDate
        start = strDate
    }
    
    @IBAction func getDateEnd(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(DateEnd.date)
        DisplayEnd.text = "Fin (optionnel : " + strDate
        end = strDate
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        print("avant d'envoyer les data.....")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let StarDate = dateFormatter.stringFromDate(DateStart.date)
        let EndDate = dateFormatter.stringFromDate(DateEnd.date)
        let myVC = storyboard!.instantiateViewControllerWithIdentifier("CreateEventVC") as! MenuOwnerAssocation
        
        myVC.EventDateStart = StarDate
        myVC.EventDateEnd = EndDate
        
        
    }
}