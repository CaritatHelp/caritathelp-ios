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
   // var date = ""
    var strDate = ""
    
    @IBOutlet weak var naissance: UIDatePicker!
    
    
    @IBAction func naissanceAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        strDate = dateFormatter.stringFromDate(naissance.date)
        //date = strDate
        print("Date : "+strDate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(nom)
        print(prenom)
        print(sex)
        
        // Used the text from the First View Controller to set the label
        //nom = receivedString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "goToMailSubscribe"){
            let secondViewController = segue.destinationViewController as! SubscribeMailController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.nom = nom
            secondViewController.prenom = prenom
            secondViewController.date = strDate
            secondViewController.gender = sex
        }
        if(segue.identifier == "goToStartSubscribe"){
            let firstViewController = segue.destinationViewController as! SubscribeCtrl
            
            // set a variable in the second view controller with the String to pass
            firstViewController.nomUser = nom
            firstViewController.prenomUser = prenom
        }
    }

    
    func textFieldShouldReturn(textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

}