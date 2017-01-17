//
//  SubscribeFinishCtrl.swift
//  Caritathelp
//
//  Created by Jeremy gros on 10/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import CoreLocation

class SubscribeFinishController: UIViewController, UITextFieldDelegate {
    
    var nom = ""
    var prenom = ""
    var gender = ""
    var date = ""
    var mail = ""
    var mdp = ""
    var city = ""
    var longitude = ""
    var latitude = ""
    let locationManager = CLLocationManager()
    fileprivate var geoOk = false
    @IBOutlet weak var termes: UISwitch!
    @IBOutlet weak var geoloc: UISwitch!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var check_termes: UILabel!
    var ok = true
    
    var request = RequestModel()
    var user_array = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundColor = self.gradientBackground()
        backgroundColor.frame = self.view.bounds
        self.background.layer.addSublayer(backgroundColor)
    }
    
    
    @IBAction func AcceptGeolocalization(_ sender: Any) {
        self.geoOk = self.geoloc.isOn
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func validSubscribe(_ sender: AnyObject) {
        
        user_array["email"] = mail
        user_array["password"] = mdp
        user_array["firstname"] = prenom
        user_array["lastname"] = nom
        user_array["birthday"] = date
        user_array["gender"] = gender
        user_array["city"] = city
        user_array["longitude"] = self.longitude
        user_array["latitude"] = self.latitude

        if(termes.isOn == false){
            check_termes.text = "Pour continuer, accepter les termes !"
        }
        else{
            if(geoloc.isOn){
                user_array["allowgps"] = "true"
            }else {
                user_array["allowgps"] = "false"
            }
        print("param == \(user_array)")
        request.request(type: "POST", param: user_array,add: "auth", callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        sharedInstance.setUser(user: User)
                        let storyboard = UIStoryboard(name:"Main",bundle: nil)
                        let TBCtrl = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarController
                        TBCtrl.user = User
                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        appdelegate.window?.rootViewController = TBCtrl
                    }
                    else {
                        self.check_termes.text = String(describing: User["message"])
                    }
                }
                else {
                    //print("isOK == = = \(isOK)")
                    self.check_termes.text = String(describing: User["message"])
                    
                }
            });
        }
    }
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToMailSubscribe"){
            
            let firstViewController = segue.destination as! SubscribeMailController
            
            // set a variable in the second view controller with the String to pass
            firstViewController.nom = nom
            firstViewController.prenom = prenom
            firstViewController.mailUser = mail
            firstViewController.gender = gender
            firstViewController.date = date
        }
    }

    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}


extension SubscribeFinishController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if geoOk {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            self.longitude = String(describing: locValue.longitude)
            self.latitude = String(describing: locValue.latitude)
            geoOk = false
        }
    }
    
}

