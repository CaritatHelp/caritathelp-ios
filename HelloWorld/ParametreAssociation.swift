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
        NomAsso.text = String(describing: Asso["response"]["name"])
        DescAsso.text = String(describing: Asso["response"]["description"])
        VilleAsso.text = String(describing: Asso["response"]["city"])
    }
    
    @IBAction func UpdateAsso(_ sender: AnyObject) {
        
        
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        param["name"] = NomAsso.text
        param["description"] = DescAsso.text
        param["city"] = VilleAsso.text
        
        
        request.request(type: "PUT", param: param,add: "associations/"+String(describing: Asso["response"]["id"]), callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Message.text = "l'association a été mis à jour !"
                self.Message.textColor = UIColor.green
                self.Asso = User
            }
            else {
                self.Message.text = "Une erreur est survenue ... "
                self.Message.textColor = UIColor.red
                
            }
        });

    }
    
}
