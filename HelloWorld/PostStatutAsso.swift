//
//  PostStatutAsso.swift
//  Caritathelp
//
//  Created by Jeremy gros on 24/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class PostStatutAssoController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var ZoneText: UITextView!
    @IBOutlet weak var Statut: UITextView!
    var assoc_array = [String: String]()
    var AssoID = ""
    var EventID = ""
    var FriendID = ""
    var user : JSON = []
    var from = ""
    var request = RequestModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        user = sharedInstance.volunteer["response"]
        Statut.text = "Exprimez-vous..."
        Statut.textColor = UIColor.lightGray
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Exprimez-vous..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func Publish(_ sender: AnyObject) {
        
        if(Statut.text == ""){
            print("Votre message est vide. Ecrivez quelque chose.")
        }else{
            self.assoc_array["access-token"] = sharedInstance.header["access-token"]
            self.assoc_array["client"] = sharedInstance.header["client"]
            self.assoc_array["uid"] = sharedInstance.header["uid"]

            assoc_array["content"] = Statut.text!
            if from == "asso" {
                assoc_array["group_id"] = AssoID
                assoc_array["group_type"] = "Assoc"
            }else if from == "event" {
                assoc_array["group_id"] = EventID
                assoc_array["group_type"] = "Event"
            }
            else {
                assoc_array["group_id"] = String(describing: user["id"])
                assoc_array["group_type"] = "Volunteer"
            }
            assoc_array["news_type"] = "Status"
            request.request(type: "POST", param: assoc_array,add: "news/wall_message", callback: {
                (isOK, User)-> Void in
                 if(isOK){
                    //self.refreshActu()
                    self.navigationController?.popViewController(animated: true)
                    SCLAlertView().showSuccess("Succès !", subTitle: "Votre message a été publié.")
                    self.ZoneText.text = "Exprimez-vous..."
                    self.ZoneText.textColor = UIColor.lightGray
                                    }
                else {
                    SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                }
            });

            }
        
        
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
//        if(identifier == "PublishStatut"){
//            
//            if(Statut.text == ""){
//                print("pas de status.....")
//                return false
//            }else{
//                assoc_array["token"] = String(user["token"])
//                assoc_array["content"] = Statut.text!
//                return true
//            }
//        }
//        return true
//    }
    
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        if(segue.identifier == "PublishStatut"){
            
            let firstViewController = segue.destination as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            firstViewController.user = user
            firstViewController.creation = true
        }
    }

}
