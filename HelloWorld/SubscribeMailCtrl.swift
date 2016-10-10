//
//  SubscribeMailCtrl.swift
//  Caritathelp
//
//  Created by Jeremy gros on 09/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit

class SubscribeMailController: UIViewController, UITextFieldDelegate {
    
    
    var nom = ""
    var prenom = ""
    var gender = ""
    var date = ""
    var mailUser = ""
    
    @IBOutlet weak var checkMail: UILabel!
    @IBOutlet weak var checkPassword: UILabel!
    @IBOutlet weak var mail: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var check_password: UITextField!
    
    @IBOutlet weak var msg_check: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        //print(gender)
        // Used the text from the First View Controller to set the label
        //nom = receivedString
        mail.text = mailUser
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func doStringContainsNumber( _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        
        return containsNumber
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if (identifier == "goToFinishSub") {
            if (mail.text!.isEmpty ) {
                
                checkMail.text = "Veuillez saisir un mail."
                return false
            }
            else if (mail.text!.range(of: "@") == nil) {
                
                checkMail.text = "Veuillez saisir un mail valide."
                return false
            }
            else if(password.text!.isEmpty && check_password.text!.isEmpty){
                checkPassword.text = "Veuillez choisir un mot de passe"
                checkMail.text = ""
                return false
            }
            else if(doStringContainsNumber(_string: password.text!) == false){
                checkPassword.text = "votre mot de passe doit contenir lettre/chiffre"
                checkMail.text = ""
                return false
            }
            else if(password.text! != check_password.text!){
                checkPassword.text = "Mots de passe non identiques"
                checkMail.text = ""
                return false
            }
            else {
                return true
            }
        }
        return true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "goToFinishSub"){
            let secondViewController = segue.destination as! SubscribeFinishController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.nom = nom
            secondViewController.prenom = prenom
            secondViewController.date = date
            secondViewController.gender = gender
            secondViewController.mail = mail.text!
            secondViewController.mdp = password.text!
        }
        if(segue.identifier == "goToDateSubscribe"){
            let firstViewController = segue.destination as! SubscribeDateController
            firstViewController.nom = nom
            firstViewController.prenom = prenom
        }
    }
}
