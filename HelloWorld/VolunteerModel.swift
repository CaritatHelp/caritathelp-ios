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
}

let define = Define()
