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

class VolunteerModel {
    
    var volunteer : JSON = []
    var header = [String: String]()
    var nb_notif = 0
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
