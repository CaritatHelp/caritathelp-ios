//
//  NewAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 14/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class NewAssociation : UIViewController {
    var user : JSON = []
    var request = RequestModel()
    var assoc_array = [String: String]()
    var Asso : JSON = []
    
    @IBOutlet weak var AssocName: UITextField!
    
    @IBOutlet weak var AssocDescription: UITextView!
    
    @IBOutlet weak var AssocVille: UITextField!
    
    @IBOutlet weak var check_request: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        user = sharedInstance.volunteer["response"]
    }
    
    @IBAction func NewAssociaiton(_ sender: AnyObject) {
        self.CreateAssociation()
    }
    
    func CreateAssociation() {
        var check = 1
        let Date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd";
        let date = formatter.string(from: Date as Date);
        
        
        
        if(AssocName.text == ""){
            check_request.text = "veuillez donner un nom à votre association ";
            
        }
        else if(AssocDescription.text == ""){
            check_request.text = "veuillez décrire votre association ";
            
        }
        else if(AssocVille.text == ""){
            check_request.text = "veuillez indiquer ou est située votre association ";
            
        }
        else{
            self.assoc_array["access-token"] = sharedInstance.header["access-token"]
            self.assoc_array["client"] = sharedInstance.header["client"]
            self.assoc_array["uid"] = sharedInstance.header["uid"]

        assoc_array["name"] = AssocName.text!
        assoc_array["description"] = AssocDescription.text!
        assoc_array["birthday"] = date
        assoc_array["city"] = AssocVille.text!
        
        
        request.request(type: "POST", param: assoc_array,add: "associations", callback: {
            (isOK, User)-> Void in
            if(isOK){
                //rediriger vers Home profil
                self.Asso = User
                _ = self.navigationController?.popViewController(animated: true)
                check = 1
            }
            else {
                //print("isOK == = = \(isOK)")
                self.check_request.text = String(describing: User["message"])
                check = 0
            }
        });
        }
        
    }
    

    
     func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
            if(identifier == "AfterCreateAssoVC"){
                
                if(AssocName.text == ""){
                    check_request.text = "veuillez donner un nom à votre association ";
                    return false
                }
                else if(AssocDescription.text == ""){
                    check_request.text = "veuillez décrire votre association ";
                    return false
                }
                else if(AssocVille.text == ""){
                    check_request.text = "veuillez indiquer ou est située votre association ";
                    return false
                }
//                else{
//                    if(CreateAssociation() == 1){
//                        return true
//                    }
//                    else{
//                        return false
//                    }
//                }
                
        }
        return true
    }

    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("value2 ok : \(ok)")
        // get a reference to the second view controller
        
        if(segue.identifier == "AfterCreateAssoVC"){
            print("oui c'est bien ca !")
        }
        
        if(segue.identifier == "goToProfilAssoc"){
            print("Asso : ")
            print(Asso);
                let firstViewController = segue.destination as! AssociationProfil
                
                // set a variable in the second view controller with the String to pass
                firstViewController.user = user
                firstViewController.Asso = Asso
                firstViewController.creation = true
        }
    }

}
