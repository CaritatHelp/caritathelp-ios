//
//  SubscribeFinishCtrl.swift
//  Caritathelp
//
//  Created by Jeremy gros on 10/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit

class SubscribeFinishController: UIViewController, UITextFieldDelegate {
    
    var nom = ""
    var prenom = ""
    var gender = ""
    var date = ""
    var mail = ""
    var mdp = ""
    
    @IBOutlet weak var termes: UISwitch!
    @IBOutlet weak var geoloc: UISwitch!
    
    @IBOutlet weak var check_termes: UILabel!
    //let SubModel = SubscribeModel()
    var ok = true
    
    var request = RequestModel()
    var user_array = [String: String]()
    @IBAction func validSubscribe(sender: AnyObject) {
        
        user_array["mail"] = mail
        user_array["password"] = mdp
        user_array["firstname"] = prenom
        user_array["lastname"] = nom
        user_array["birthday"] = date
        user_array["gender"] = gender
        
        if(termes.on == false){
            check_termes.text = "Pour continuer, accepter les termes !"
        }
        else{
            if(geoloc.on){
                user_array["allowgps"] = "true"
            }else {
                user_array["allowgps"] = "false"
            }
            
        request.request("POST", param: user_array,add: "volunteers", callback: {
                (isOK, User)-> Void in
                if(isOK){
//                    //rediriger vers Home profil
//                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC") as! HomeController
//                    //Pass delegate and variable to vc which is HomeController
//                    vc.user = User
//                    
//                    self.presentViewController(vc, animated: true, completion: nil)
//                    
                    let storyboard = UIStoryboard(name:"Main",bundle: nil)
                    let TBCtrl = storyboard.instantiateViewControllerWithIdentifier("TabBarVC") as! TabBarController
                    TBCtrl.user = User
                    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appdelegate.window?.rootViewController = TBCtrl
                    
                }
                else {
                    //print("isOK == = = \(isOK)")
                    self.check_termes.text = String(User["message"])
                    
                }
            });
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //print("value2 ok : \(ok)")
        // get a reference to the second view controller
        if(segue.identifier == "goToMailSubscribe"){
            
            let firstViewController = segue.destinationViewController as! SubscribeMailController
            
            // set a variable in the second view controller with the String to pass
            firstViewController.nom = nom
            firstViewController.prenom = prenom
            firstViewController.mailUser = mail
            firstViewController.gender = gender
            firstViewController.date = date
        }
    }

    
    func textFieldShouldReturn(textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}


