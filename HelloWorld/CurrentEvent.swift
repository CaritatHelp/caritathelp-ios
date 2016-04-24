//
//  File.swift
//  Caritathelp
//
//  Created by Jeremy gros on 15/04/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import SwiftyJSON

class CurrentEventModel {
    
    var currentEvent : JSON = []

}

//singleton (variable accessible partout dans le code)
let currentEvent = CurrentEventModel()