//
//  gestionCompte.swift
//  Caritathelp
//
//  Created by Jeremy gros on 10/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class GestionCompte : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Prenom: UITextField!
    @IBOutlet weak var Nom: UITextField!
    @IBOutlet weak var Mail: UITextField!
    @IBOutlet weak var old_password: UITextField!
    @IBOutlet weak var new_password: UITextField!
    @IBOutlet weak var new_check_password: UITextField!
    @IBOutlet weak var Message: UILabel!
    var user : JSON = []
    var param = [String: String]()
    var request = RequestModel()
    //var volunteer = VolunteerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        user = sharedInstance.volunteer
        print("DANS UPDATE // ")
        print(user)
        Prenom.text = String(user["response"]["firstname"])
        Nom.text = String(user["response"]["lastname"])
        Mail.text = String(user["response"]["mail"])
        
    }

    func doStringContainsNumber( _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluateWithObject(_string)
        
        return containsNumber
    }

    
    func beforeUpdate() -> Bool{
        self.Message.textColor = UIColor.redColor()
        if(Prenom.text == "" || Nom.text == "" || Mail.text == ""){
            Message.text = "Veuillez remplir vos informations."
            return false
        }
        if(old_password.text != ""){
            if(old_password.text != String(user["response"]["password"])){
                Message.text = "Votre ancien mot de passe ne correspond pas..."
                return false
            }
            if(doStringContainsNumber(new_password.text!) == false){
                Message.text = "votre mot de passe doit contenir lettre/chiffre"
                return false
            }
            if(new_password.text != new_check_password.text){
                Message.text = "Votre nouveau mot de passe ne correspond pas..."
                return false
            }
        }
        return true;
    }
    
    @IBAction func UpdateProfil(sender: AnyObject) {
        
        if (beforeUpdate() == true) {
        
        param["token"] = String(user["response"]["token"])
        param["mail"] = Mail.text
        param["password"] = new_password.text == "" ?String(user["response"]["password"]) : new_password.text
        param["firstname"] = Prenom.text
        param["lastname"] = Nom.text

        
        request.request("PUT", param: param,add: "volunteers/"+String(user["response"]["id"]), callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Message.text = "Votre profil à été mis à jour !"
                self.Message.textColor = UIColor.greenColor()
                self.user = User
                sharedInstance.setUser(User)
            }
            else {
                self.Message.text = "Une erreur est survenue ... "
                self.Message.textColor = UIColor.redColor()

            }
        });
    
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
}
