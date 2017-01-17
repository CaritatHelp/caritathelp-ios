//
//  VolunteerModel.swift
//  Caritathelp
//
//  Created by Jeremy gros on 10/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreLocation

class VolunteerModel: NSObject {
    
    var volunteer : JSON = []
    var header = [String: String]()
    var nb_notif = 0
    let locationManager = CLLocationManager()
    var allowgps = false
    var refreshPosition = true
    var timer = Timer()
    var request = RequestModel()
    var param = [String: String]()
    var longitude = ""
    var latitude = ""
    
    func setUser(user : JSON){
        volunteer = user
        print("DATA SEND TO MODEL")
        print(volunteer)
    }
    
    func getUser() -> JSON {
        print("AVANT DENVOYER DES DATAS !")
        print(volunteer)
        return volunteer
    }
    
    func AcceptGeolocalisation () {
        print("\(self.volunteer["response"]["allowgps"])")
        if self.volunteer["response"]["allowgps"] == true {
            self.allowgps = true
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                //locationManager.startUpdatingLocation()
                self.refreshGeoposition()
            }
        }
        else {
            self.locationManager.stopUpdatingLocation()
            timer.invalidate()
            timer.fire()
        }
    }
    
    func refreshGeoposition() {
        if allowgps {
            self.locationManager.startUpdatingLocation()
            timer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: allowgps, block: { (timer) in
                self.refreshPosition = true
                self.sendGeoposition()
            })
        }
        else {
            self.locationManager.stopUpdatingLocation()
            timer.invalidate()
            timer.fire()
        }
    }
    
    func sendGeoposition() {
        self.param["access-token"] = self.header["access-token"]
        self.param["client"] = self.header["client"]
        self.param["uid"] = self.header["uid"]
        self.param["latitude"] = self.latitude
        self.param["longitude"] = self.longitude
        let val = "auth/"
        request.request(type: "PUT", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                if User["status"] == 200 {
                    self.volunteer = User["response"]
                }
            }
            else {
                
            }
        });

    }
}

extension VolunteerModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            self.longitude = String(describing: locValue.longitude)
            self.latitude = String(describing: locValue.latitude)
        }
}


//singleton (variable accessible partout dans le code)
let sharedInstance = VolunteerModel()

class Define {
    var path_picture = "http://staging.caritathelp.me"//"http://api.caritathelp.me"
    var nb_notif = "0"
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: width,height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    static func doStringContainsNumber( _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        
        return containsNumber
    }
}

let define = Define()
