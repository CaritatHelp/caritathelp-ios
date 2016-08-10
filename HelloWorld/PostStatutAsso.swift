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

class PostStatutAssoController : UIViewController, UITextViewDelegate {
    
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
                assoc_array["assoc_id"] = AssoID
            }else if from == "event" {
                assoc_array["event_id"] = EventID
            }
            request.request("POST", param: assoc_array,add: "news/wall_message", callback: {
                (isOK, User)-> Void in
                 if(isOK){
                    //self.refreshActu()
                    print("POst OK !!")
                }
                else {
                    print("erreur de requete ... ")
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