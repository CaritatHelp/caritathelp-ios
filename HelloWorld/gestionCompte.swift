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
        Prenom.text = String(describing: user["response"]["firstname"])
        Nom.text = String(describing: user["response"]["lastname"])
        Mail.text = String(describing: user["response"]["mail"])
        
    }

    func doStringContainsNumber( _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        
        return containsNumber
    }

    
    func beforeUpdate() -> Bool{
        self.Message.textColor = UIColor.red
        if(Prenom.text == "" || Nom.text == "" || Mail.text == ""){
            Message.text = "Veuillez remplir vos informations."
            return false
        }
        if(old_password.text != ""){
            if(old_password.text != String(describing: user["response"]["password"])){
                Message.text = "Votre ancien mot de passe ne correspond pas..."
                return false
            }
            if(doStringContainsNumber(_string: new_password.text!) == false){
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
    
    @IBAction func UpdateProfil(_ sender: AnyObject) {
        
        if (beforeUpdate() == true) {
        
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

        self.param["mail"] = Mail.text
        self.param["password"] = new_password.text == "" ?String(describing: user["response"]["password"]) : new_password.text
        self.param["firstname"] = Prenom.text
        self.param["lastname"] = Nom.text

        
        request.request(type: "PUT", param: self.param,add: "volunteers/"+String(describing: user["response"]["id"]), callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Message.text = "Votre profil à été mis à jour !"
                self.Message.textColor = UIColor.green
                self.user = User
                sharedInstance.setUser(user: User)
            }
            else {
                self.Message.text = "Une erreur est survenue ... "
                self.Message.textColor = UIColor.red

            }
        });
    
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
}
