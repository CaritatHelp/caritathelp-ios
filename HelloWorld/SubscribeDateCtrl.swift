//
//  SubscribeDateCtrl.swift
//  Caritathelp
//
//  Created by Jeremy gros on 09/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit

class SubscribeDateController: UIViewController {
    var nom = ""
    var prenom = ""
    var sex = ""
    var city = ""
    var strDate = ""
    
    @IBOutlet weak var naissance: UIDatePicker!
    @IBOutlet weak var background: UIView!
    
    
    @IBAction func naissanceAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        strDate = dateFormatter.string(from: naissance.date)
        //date = strDate
        print("Date : "+strDate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(nom)
        print(prenom)
        print(sex)
        let backgroundColor = self.gradientBackground()
        backgroundColor.frame = self.view.bounds
        self.background.layer.addSublayer(backgroundColor)
        self.naissance.maximumDate = NSDate() as Date
        // Used the text from the First View Controller to set the label
        //nom = receivedString
    }
    
    @IBAction func backAction(_ sender: Any) {
           _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Main",bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "SubscribeMailVC") as! SubscribeMailController
        secondViewController.nom = nom
        secondViewController.prenom = prenom
        secondViewController.date = strDate
        secondViewController.gender = sex
        secondViewController.city = city
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "goToMailSubscribe"){
            let secondViewController = segue.destination as! SubscribeMailController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.nom = nom
            secondViewController.prenom = prenom
            secondViewController.date = strDate
            secondViewController.gender = sex
            secondViewController.city = city
        }
        if(segue.identifier == "goToStartSubscribe"){
            let firstViewController = segue.destination as! SubscribeCtrl
            
            // set a variable in the second view controller with the String to pass
            firstViewController.nomUser = nom
            firstViewController.prenomUser = prenom
            firstViewController.ville = city
        }
    }

    
    func textFieldShouldReturn(textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

}
