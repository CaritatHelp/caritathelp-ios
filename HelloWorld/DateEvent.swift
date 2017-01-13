//
//  DateEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 15/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import SwiftyJSON
import UIKit
import SCLAlertView
import MapKit

class DateCreateEvent : UIViewController {
    
    @IBOutlet weak var DisplayStart: UILabel!
    @IBOutlet weak var DisplayEnd: UILabel!
    @IBOutlet weak var DateStart: UIDatePicker!
    @IBOutlet weak var DateEnd: UIDatePicker!
    
    var request = RequestModel()
    var param = [String: String]()
    var user : JSON = []
    var start = ""
    var end = ""
    var eventTitle = ""
    var city = ""
    var descp = ""
    var state = ""
    var AssocID = ""
    var longitude = ""
    var latitude = ""
    
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
    
    @IBAction func CreateEvent(_ sender: Any) {
        if (DisplayStart.text!.isEmpty) {
            SCLAlertView().showError("Attention", subTitle: "veuillez donner une date de début à votre évènement")
        }
        else if DateStart.date.compare(DateEnd.date) == .orderedDescending {
            SCLAlertView().showError("Attention", subTitle: "La fin ne peut être avant le début... ")
        }
        else {
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            param["assoc_id"] = AssocID
            param["title"] = eventTitle
            param["description"] = descp
            param["place"] = city
            param["begin"] = start
            param["end"] = end
            param["private"] = state
            param["latitude"] = latitude
            param["longitude"] = longitude

            
            
            let val = "events"
            request.request(type: "POST", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        SCLAlertView().showSuccess("Succès", subTitle: "Votre évènement a bien été créer !")
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            });
        }
    }
}
