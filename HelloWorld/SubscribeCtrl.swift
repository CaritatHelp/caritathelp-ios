//
//  SubscribeCtrl.swift
//  HelloWorld
//
//  Created by Jeremy gros on 16/12/2015.
//  Copyright © 2015 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class SubscribeCtrl: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var Prenom: UITextField!
    @IBOutlet weak var Nom: UITextField!
    
    @IBOutlet weak var checkLabel: UILabel!
    var nomUser: String!
    var prenomUser: String!
    var sexUser = "m"
    
    let genders = ["homme", "femme"]
    
    @IBOutlet weak var sex: UISegmentedControl!
    @IBAction func changeSex(_ sender: AnyObject) {
        switch sex.selectedSegmentIndex
        {
        case 0:
            sexUser = "m";
        case 1:
            sexUser = "f";
        default:
            break; 
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.nomUser = ""
        self.prenomUser = ""
        Nom.text! = nomUser
        Prenom.text! = prenomUser
        
        self.sex.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.top.equalTo(self.view.snp.bottom).offset(-250.0)
            make.centerX.equalTo(self.view)
        }
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if (identifier == "goToDateSubsribe") {
            
            if (Nom.text!.isEmpty && Prenom.text!.isEmpty) {
                
                checkLabel.text = "Veuillez remplir tous les champs."
                return false
            }
                
            else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "goToDateSubsribe"){
            let secondViewController = segue.destination as! SubscribeDateController
            print("sex : "+sexUser)
            // set a variable in the second view controller with the String to pass
            secondViewController.nom = Nom.text!
            secondViewController.prenom = Prenom.text!
            secondViewController.sex = sexUser
        }
        //secondViewController.gender = Sex
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
}
