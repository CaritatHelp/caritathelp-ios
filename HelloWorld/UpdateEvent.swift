//
//  UpdateEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 14/04/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class UpdateEventController : UIViewController {
    var Event : JSON = []
    var user : JSON = []

    @IBOutlet weak var TitleEvent: UITextField!
    @IBOutlet weak var PlaceEvent: UITextField!
    @IBOutlet weak var StartDate: UILabel!
    @IBOutlet weak var EndDate: UILabel!
    @IBOutlet weak var DescEvent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        TitleEvent.text = String(Event["title"])
        PlaceEvent.text = String(Event["place"])
        StartDate.text = String(Event["begin"])
        EndDate.text = String(Event["end"])
        DescEvent.text = String(Event["description"])

    }
    
    @IBAction func updateEvent(sender: AnyObject) {
        SCLAlertView().showSuccess("Success", subTitle: "Votre évènement à bien été mise à jour")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "goToUpdateDateEvent"){
            let navController = segue.destinationViewController as! UINavigationController
            let VC = navController.topViewController as! UpdateEventDateController
            VC.start = StartDate.text!
            VC.end = EndDate.text!
        }
    }

    
    @IBAction func unwindToUpdateEvent(sender: UIStoryboardSegue) {
        let data = sender.sourceViewController as! UpdateEventDateController
        StartDate.text = data.start
        EndDate.text = data.end
    }
    
    @IBAction func unwindToUpdateEventCancel(sender: UIStoryboardSegue) {
        _ = sender.sourceViewController
    }
    


}
