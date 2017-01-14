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
    var city = ""
    
    @IBOutlet weak var checkMail: UILabel!
    @IBOutlet weak var checkPassword: UILabel!
    @IBOutlet weak var mail: UITextField!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var check_password: UITextField!
    
    @IBOutlet weak var msg_check: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let backgroundColor = self.gradientBackground()
        backgroundColor.frame = self.view.bounds
        self.background.layer.addSublayer(backgroundColor)
        //print(gender)
        // Used the text from the First View Controller to set the label
        //nom = receivedString
        mail.text = mailUser
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if (mail.text!.isEmpty ) {
            checkMail.text = "Veuillez saisir un mail."
        }
        else if (mail.text!.range(of: "@") == nil) {
            checkMail.text = "Veuillez saisir un mail valide."
        }
        else if(password.text!.isEmpty && check_password.text!.isEmpty){
            checkPassword.text = "Veuillez choisir un mot de passe"
            checkMail.text = ""
        }
        else if(Define.doStringContainsNumber(_string: password.text!) == false){
            checkPassword.text = "votre mot de passe doit contenir lettre/chiffre"
            checkMail.text = ""
        }
        else if(password.text! != check_password.text!){
            checkPassword.text = "Mots de passe non identiques"
            checkMail.text = ""

        }
        else {
            let storyboard = UIStoryboard(name:"Main",bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "SubscribeFinishVC") as! SubscribeFinishController
            secondViewController.nom = nom
            secondViewController.prenom = prenom
            secondViewController.date = date
            secondViewController.gender = gender
            secondViewController.city = city
            secondViewController.mail = mail.text!
            secondViewController.mdp = password.text!
            
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }

        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "goToFinishSub") {
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
            secondViewController.city = city
            secondViewController.mail = mail.text!
            secondViewController.mdp = password.text!
        }
        if(segue.identifier == "goToDateSubscribe"){
            let firstViewController = segue.destination as! SubscribeDateController
            firstViewController.nom = nom
            firstViewController.prenom = prenom
            firstViewController.city = city
        }
    }
}
