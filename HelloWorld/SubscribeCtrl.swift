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
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var checkLabel: UILabel!
    var nomUser: String!
    var prenomUser: String!
    var sexUser = "m"
    var ville = ""
    
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
        self.navigationController?.navigationBar.isHidden = true
        let backgroundColor = self.gradientBackground()
        backgroundColor.frame = self.view.bounds
        self.background.layer.addSublayer(backgroundColor)
        self.sex.backgroundColor = UIColor.white
        self.sex.layer.cornerRadius = 5.0
        self.sex.layer.masksToBounds = true
        self.sex.tintColor = UIColor.GreenBasicCaritathelp()
        self.nomUser = ""
        self.prenomUser = ""
        Nom.text! = nomUser
        Prenom.text! = prenomUser
        city.text! = ville
        
        self.sex.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.top.equalTo(self.view.snp.bottom).offset(-250.0)
            make.centerX.equalTo(self.view)
        }
    }
    @IBAction func backToLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
//    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if (identifier == "goToDateSubsribe") {
//            
//            if (Nom.text!.isEmpty || Prenom.text!.isEmpty || city.text!.isEmpty) {
//                checkLabel.text = "Veuillez remplir tous les champs."
//                return false
//            }
//                
//            else {
//                return true
//            }
//        }
//        return true
//    }
//    
    @IBAction func goToDateSubscribe(_ sender: Any) {
        if (Nom.text!.isEmpty || Prenom.text!.isEmpty || city.text!.isEmpty) {
            checkLabel.text = "Veuillez remplir tous les champs."
        }
        else {
            
            let storyboard = UIStoryboard(name:"Main",bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "SubscribeDateVC") as! SubscribeDateController
            //let secondViewController = SubscribeDateController()
            print("sex : "+sexUser)
            // set a variable in the second view controller with the String to pass
            secondViewController.nom = Nom.text!
            secondViewController.prenom = Prenom.text!
            secondViewController.sex = sexUser
            secondViewController.city = city.text!
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }

//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        // get a reference to the second view controller
//        if(segue.identifier == "goToDateSubsribe"){
//            
//            let svc = segue.destination as? UINavigationController
//            let secondViewController: SubscribeDateController = svc?.topViewController as! SubscribeDateController
//            print("sex : "+sexUser)
//            // set a variable in the second view controller with the String to pas
//            secondViewController.nom = Nom.text!
//            secondViewController.prenom = Prenom.text!
//            secondViewController.sex = sexUser
//            secondViewController.city = city.text!
//        }
//        //secondViewController.gender = Sex
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
        
    }
}
