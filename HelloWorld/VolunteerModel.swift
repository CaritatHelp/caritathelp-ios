//
//  VolunteerModel.swift
//  Caritathelp
//
//  Created by Jeremy gros on 10/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import SwiftyJSON

class VolunteerModel {
    
    var volunteer : JSON = []
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
    var path_picture = "http://api.caritathelp.me"    
}

let define = Define()