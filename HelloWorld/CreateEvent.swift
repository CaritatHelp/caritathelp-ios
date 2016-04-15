//
//  CreateEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 13/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CreateEvent : UIViewController {
    
    @IBOutlet weak var titleEvent: UITextField!
    @IBOutlet weak var cityEvent: UITextField!
    @IBOutlet weak var DescEvent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //pour chacher le clavier en touchant ailleur sur l'écran
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //fonction pour être rediriger après un exit pour revenir sur cette view
    @IBAction func unwindToSecondVC(sender: UIStoryboardSegue) {
        print("******************** JUOUIJUIKRZQC")
        _ = sender.sourceViewController
    }

    //avant le changement d'une vue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //print("value2 ok : \(ok)")
        // get a reference to the second view controller
        if(segue.identifier == "goToDateCreateEvent"){
            
            let firstViewController = segue.destinationViewController as! DateCreateEvent
            
            // set a variable in the second view controller with the String to pass
            firstViewController.eventTitle = titleEvent.text!
            firstViewController.city = cityEvent.text!
            firstViewController.descp = DescEvent.text!
        }
    }
    
    
    func textFieldShouldReturn(textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
