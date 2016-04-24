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
   // variable utilisé dans cette classe
    var Event : JSON = []
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    
    //variable en lien avec la storyBoard
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
        StartDate.text = "début : " + String(Event["begin"])
        EndDate.text = "fin : " + String(Event["end"])
        DescEvent.text = String(Event["description"])

    }
    
    @IBAction func updateEvent(sender: AnyObject) {
        if(TitleEvent.text!.isEmpty){
            SCLAlertView().showError("Attention", subTitle: "Votre évènement doit avoir un nom")
        }else if (PlaceEvent.text!.isEmpty){
            SCLAlertView().showError("Attention", subTitle: "Votre évènement se passe surement quelque part !")
        }else if (DescEvent.text!.isEmpty){
            SCLAlertView().showError("Attention", subTitle: "Une description aide à la compréhension \n du but de l'évènement !")
            
        }else {
            
            param["token"] = String(user["token"])
            param["title"] = TitleEvent.text
            param["description"] = DescEvent.text
            param["place"] = PlaceEvent.text
            param["begin"] = StartDate.text
            param["end"] = EndDate.text
            let path = "events/" + String(Event["id"])
            
            request.request("PUT", param: param,add: path, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    currentEvent.currentEvent = User["response"]
                    SCLAlertView().showSuccess("Success", subTitle: "Votre évènement à bien été mise à jour")
                }
                else {
                    SCLAlertView().showError("Attention", subTitle: "Une erreur est survenue...")
                }
            });

            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "goToUpdateDateEvent"){
            //envoyer les dates au controller sur le dates
            let navController = segue.destinationViewController as! UINavigationController
            let VC = navController.topViewController as! UpdateEventDateController
            VC.start = StartDate.text!
            VC.end = EndDate.text!
        }
    }

    
    @IBAction func unwindToUpdateEvent(sender: UIStoryboardSegue) {
        let data = sender.sourceViewController as! UpdateEventDateController
        StartDate.text = "début : " + data.start
        EndDate.text = "fin : " + data.end
    }
    
    @IBAction func unwindToUpdateEventCancel(sender: UIStoryboardSegue) {
        _ = sender.sourceViewController
    }
    


}
