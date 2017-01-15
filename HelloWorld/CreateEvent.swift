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
import MapKit

class CreateEvent : UIViewController {
    
        //variable en lien avec la storyBoard
    @IBOutlet weak var titleEvent: UITextField!
    @IBOutlet weak var cityEvent: UITextField!
    @IBOutlet weak var DescEvent: UITextView!
    @IBOutlet weak var stateEvent: UISegmentedControl!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var city: UITextField!
    
    var AssocID = ""
    var latitude = ""
    var longitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        self.stateEvent.setTitle("Public", forSegmentAt: 0)
        self.stateEvent.setTitle("Privé", forSegmentAt: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwindToSecondVC(_ sender: UIStoryboardSegue) {
        _ = sender.source
    }
    
    func getLocalisation(_ address: String, completion:@escaping ((_ finished: Bool) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let placemark = placemarks[0] as CLPlacemark
                    let location = placemark.location
                    
                    self.latitude = String(describing: location!.coordinate.latitude)
                    self.longitude = String(describing: location!.coordinate.longitude)
                    
                    print("before : \(self.latitude, self.longitude, placemark.country)")
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
            else {
                completion(false)
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if (titleEvent.text!.isEmpty) {
            SCLAlertView().showError("Attention", subTitle: "veuillez donner un nom à votre évènement")
        }
        else if (cityEvent.text!.isEmpty) {
            SCLAlertView().showError("Attention", subTitle: "veuillez donner une adresse à votre évènement")
        }
        else if (zipCode.text!.isEmpty) {
            SCLAlertView().showError("Attention", subTitle: "veuillez donner un code postal à votre évènement")
        }
        else if (city.text!.isEmpty) {
            SCLAlertView().showError("Attention", subTitle: "veuillez donner une ville à votre évènement")
        }
        else if (DescEvent.text!.isEmpty) {
            SCLAlertView().showError("Attention", subTitle: "veuillez décrire votre évènement")
        }
        else {
            let address = cityEvent.text! + " " + zipCode.text! + " " + city.text!
            self.getLocalisation(address, completion: { (finished) in
                
                
                if finished {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "DateCreateEventVC") as! DateCreateEvent
                    controller.eventTitle = self.titleEvent.text!
                    controller.city = address
                    controller.descp = self.DescEvent.text!
                    controller.state = self.stateEvent.selectedSegmentIndex == 0 ? "false" : "true"
                    controller.AssocID = self.AssocID
                    controller.longitude = self.longitude
                    controller.latitude = self.latitude
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                else {
                    SCLAlertView().showError("Attention", subTitle: "votre adresse n'existe pas")
                }
            })
        }

    }
    
//
//    func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
//        if (identifier == "goToDateCreateEvent") {
//            
//            if (titleEvent.text!.isEmpty) {
//                SCLAlertView().showError("Attention", subTitle: "veuillez donner un nom à votre évènement")
//                return false
//            }
//            else if (cityEvent.text!.isEmpty) {
//                SCLAlertView().showError("Attention", subTitle: "veuillez donner une adresse à votre évènement")
//                return false
//            }
//            else if (zipCode.text!.isEmpty) {
//                SCLAlertView().showError("Attention", subTitle: "veuillez donner un code postal à votre évènement")
//                return false
//            }
//            else if (city.text!.isEmpty) {
//                SCLAlertView().showError("Attention", subTitle: "veuillez donner une ville à votre évènement")
//                return false
//            }
//            else if (DescEvent.text!.isEmpty) {
//                SCLAlertView().showError("Attention", subTitle: "veuillez décrire votre évènement")
//                return false
//            }
//            else {
//                let address = cityEvent.text! + " " + zipCode.text! + " " + city.text!
//                self.getLocalisation(address, completion: { (finished) in
//                    SCLAlertView().showError("Attention", subTitle: "votre ville n'existe pas")
//                    //return false
//                })
//                return false
//            }
//            return false
//        }
//        
//        // by default, transition
//        return true
//    }
//
//    @IBAction func modifyStateEvent(_ sender: Any) {
//        if self.stateEvent.selectedSegmentIndex == 0 {
//            
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //print("value2 ok : \(ok)")
//        // get a reference to the second view controller
//        if(segue.identifier == "goToDateCreateEvent"){
//            
//            let firstViewController = segue.destination as! DateCreateEvent
//            
//            // set a variable in the second view controller with the String to pass
//            firstViewController.eventTitle = titleEvent.text!
//            firstViewController.city = cityEvent.text!
//            firstViewController.descp = DescEvent.text!
//            firstViewController.state = self.stateEvent.selectedSegmentIndex == 0 ? "false" : "true"
//            firstViewController.AssocID = self.AssocID
//        }
//    }
    
    
    func textFieldShouldReturn(textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
