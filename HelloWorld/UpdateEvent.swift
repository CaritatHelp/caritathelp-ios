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
        self.hideKeyboardWhenTappedAround()
        user = sharedInstance.volunteer["response"]
        TitleEvent.text = String(describing: Event["title"])
        PlaceEvent.text = String(describing: Event["place"])
        StartDate.text = "début : " + String(describing: Event["begin"]).transformToDate() + " à " + String(describing: Event["begin"]).getHeureFromString()
        EndDate.text = "fin : " + String(describing: Event["end"]).transformToDate() + " à " + String(describing: Event["end"]).getHeureFromString()
        DescEvent.text = String(describing: Event["description"])

    }
    
    @IBAction func updateEvent(_ sender: AnyObject) {
        if(TitleEvent.text!.isEmpty){
            SCLAlertView().showError("Attention", subTitle: "Votre évènement doit avoir un nom")
        }else if (PlaceEvent.text!.isEmpty){
            SCLAlertView().showError("Attention", subTitle: "Votre évènement se passe surement quelque part !")
        }else if (DescEvent.text!.isEmpty){
            SCLAlertView().showError("Attention", subTitle: "Une description aide à la compréhension \n du but de l'évènement !")
            
        }else {
            
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            param["title"] = TitleEvent.text
            param["description"] = DescEvent.text
            param["place"] = PlaceEvent.text
            param["begin"] = StartDate.text
            param["end"] = EndDate.text
            let path = "events/" + String(describing: Event["id"])
            
            request.request(type: "PUT", param: param,add: path, callback: {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        if(segue.identifier == "goToUpdateDateEvent"){
            //envoyer les dates au controller sur le dates
            let navController = segue.destination as! UINavigationController
            let VC = navController.topViewController as! UpdateEventDateController
            VC.start = StartDate.text!
            VC.end = EndDate.text!
        }
        if(segue.identifier == "gotoemergency"){
            //envoyer les dates au controller sur le dates
            let secondViewController = segue.destination as! EmergencyViewController
            secondViewController.eventID = String(describing: self.Event["id"])
        }
        
    }

    
    @IBAction func unwindToUpdateEvent(_ sender: UIStoryboardSegue) {
        let data = sender.source as! UpdateEventDateController
        StartDate.text = "début : " + data.start.transformToDate() + " à " + data.start.getHeureFromString()
        EndDate.text = "fin : " + data.end.transformToDate() + " à " + data.end.getHeureFromString()
    }
    
    @IBAction func unwindToUpdateEventCancel(_ sender: UIStoryboardSegue) {
        _ = sender.source
    }
    


}
