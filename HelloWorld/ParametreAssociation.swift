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
    var AssocId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        user = sharedInstance.volunteer["response"]
        NomAsso.text = String(describing: Asso["name"])
        DescAsso.text = String(describing: Asso["description"])
        VilleAsso.text = String(describing: Asso["city"])
        self.loadData()
        
    }
    
    func loadData() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        self.request.request(type: "GET", param: param,add: "associations/"+self.AssocId, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Asso = User["response"]
                self.NomAsso.text = String(describing: self.Asso["name"])
                self.DescAsso.text = String(describing: self.Asso["description"])
                self.VilleAsso.text = String(describing: self.Asso["city"])
            }
            else {
                self.Message.text = "Une erreur est survenue ... "
                self.Message.textColor = UIColor.red
                
            }
        });
    }
    
    @IBAction func UpdateAsso(_ sender: AnyObject) {
        
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        self.param["name"] = NomAsso.text
        self.param["description"] = DescAsso.text
        self.param["city"] = VilleAsso.text
        
        
        self.request.request(type: "PUT", param: param,add: "associations/"+String(describing: self.Asso["id"]), callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Asso = User["response"]
                self.Message.text = "l'association a été mis à jour !"
                self.Message.textColor = UIColor.green
            }
            else {
                self.Message.text = "Une erreur est survenue ... "
                self.Message.textColor = UIColor.red
                
            }
        });

    }
    
}
