//
//  UpdateEventDate.swift
//  Caritathelp
//
//  Created by Jeremy gros on 14/04/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class UpdateEventDateController: UIViewController {
    var start = ""
    var end = ""
    @IBOutlet weak var DisplayStart: UILabel!
    @IBOutlet weak var DisplayEnd: UILabel!
    @IBOutlet weak var StartPicker: UIDatePicker!
    @IBOutlet weak var EndPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let dateString = "12-11-2015 10:50:00"
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//        print(start)
//        let date = dateFormatter.dateFromString(start)
//        let date2 = dateFormatter.dateFromString(end)
//        print(date)
//        StartPicker.setDate(date!, animated: false)
//        EndPicker.setDate(date2!, animated: false)
        
        DisplayStart.text = start
        DisplayEnd.text = end
    }
   
    @IBAction func ChangeStart(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: StartPicker.date)
        DisplayStart.text = "Début : " + strDate
        start = strDate
    }
    
    @IBAction func ChangeEnd(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: EndPicker.date)
        DisplayEnd.text = "Fin : " + strDate
        end = strDate
    }
    
}
