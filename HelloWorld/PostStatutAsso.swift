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
        Statut.textColor = UIColor.lightGrayColor()
    }
    
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Exprimez-vous..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    @IBAction func Publish(sender: AnyObject) {
        
        if(Statut.text == ""){
            print("pas de status.....")
        }else{
            assoc_array["token"] = String(user["token"])
            assoc_array["content"] = Statut.text!
            if from == "asso" {
                assoc_array["group_id"] = AssoID
                assoc_array["group_type"] = "Assoc"
            }else if from == "event" {
                assoc_array["group_id"] = EventID
                assoc_array["group_type"] = "Event"
            }
            else {
                assoc_array["group_id"] = String(user["id"])
                assoc_array["group_type"] = "Volunteer"
            }
            assoc_array["news_type"] = "Status"
            request.request("POST", param: assoc_array,add: "news/wall_message", callback: {
                (isOK, User)-> Void in
                 if(isOK){
                    //self.refreshActu()
                    SCLAlertView().showSuccess("Succès !", subTitle: "Votre message a été publié.")
                    self.ZoneText.text = "Exprimez-vous..."
                    self.ZoneText.textColor = UIColor.lightGrayColor()
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
        if(segue.identifier == "PublishStatut"){
            
            let firstViewController = segue.destinationViewController as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            firstViewController.user = user
            firstViewController.creation = true
        }
    }

}