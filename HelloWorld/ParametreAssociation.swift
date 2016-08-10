//
//  ParametreAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 12/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ParametreAssociations : UIViewController {

    @IBOutlet weak var NomAsso: UITextField!
    @IBOutlet weak var DescAsso: UITextView!
    @IBOutlet weak var VilleAsso: UITextField!
    var Asso : JSON = []
    var user : JSON = []
    var param = [String: String]()
    var request = RequestModel()
    @IBOutlet weak var Message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        NomAsso.text = String(Asso["response"]["name"])
        DescAsso.text = String(Asso["response"]["description"])
        VilleAsso.text = String(Asso["response"]["city"])
    }
    
    @IBAction func UpdateAsso(sender: AnyObject) {
        
        
        param["token"] = String(user["token"])
        param["name"] = NomAsso.text
        param["description"] = DescAsso.text
        param["city"] = VilleAsso.text
        
        
        request.request("PUT", param: param,add: "associations/"+String(Asso["response"]["id"]), callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Message.text = "l'association a été mis à jour !"
                self.Message.textColor = UIColor.greenColor()
                self.Asso = User
            }
            else {
                self.Message.text = "Une erreur est survenue ... "
                self.Message.textColor = UIColor.redColor()
                
            }
        });

    }
    
}