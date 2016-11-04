//
//  CreateEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 13/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class CreateEvent : UIViewController {
    
        //variable en lien avec la storyBoard
    @IBOutlet weak var titleEvent: UITextField!
    @IBOutlet weak var cityEvent: UITextField!
    @IBOutlet weak var DescEvent: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwindToSecondVC(_ sender: UIStoryboardSegue) {
        print("******************** JUOUIJUIKRZQC")
        _ = sender.source
    }

    func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if (identifier == "goToDateCreateEvent") {
            
            if (titleEvent.text!.isEmpty) {
                SCLAlertView().showError("Attention", subTitle: "veuillez donner un nom à votre évènement")
                return false
            }
            else if (cityEvent.text!.isEmpty) {
                SCLAlertView().showError("Attention", subTitle: "veuillez donner un lieu à votre évènement")
                return false
            }
            else if (DescEvent.text!.isEmpty) {
                SCLAlertView().showError("Attention", subTitle: "veuillez décrire votre évènement")
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
        //print("value2 ok : \(ok)")
        // get a reference to the second view controller
        if(segue.identifier == "goToDateCreateEvent"){
            
            let firstViewController = segue.destination as! DateCreateEvent
            
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
