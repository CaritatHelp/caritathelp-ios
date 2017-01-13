//
//  MenuOwnerAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 25/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class MenuOwnerAssocation: UIViewController {
    var user : JSON = []
    var Asso : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var AssocId = ""
    
    //data for create event
    var EventDateStart = ""
    var EventDateEnd = ""
    @IBOutlet weak var DisplayDateEvent: UILabel!
    @IBOutlet weak var ManageInvitationsBtn: UIButton!

    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        if String(describing: self.Asso["rights"]) != "owner" {
            self.deleteButton.isHidden = true
        }
        self.ManageInvitationsBtn.addTarget(self, action: #selector(moveToManageDemand), for: .touchUpInside)
        
    }

//    override func viewWillAppear(animated: Bool) {
//        print("avnat ..... encore.... \(self.restorationIdentifier) ")
//        if (self.restorationIdentifier == "CreateEventVC2"){
//            print("entrer pour mettre de la data")
//            DisplayDateEvent.text = "LOL : " + EventDateStart + "\n" + EventDateEnd
//        }
//
//                }
//
    func moveToManageDemand() {
        let controller = ManageDemandViewController()
        controller.AssocID = self.AssocId
        controller.from = "asso"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func goToCreateEvent(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateEventVC2") as! CreateEvent
        vc.AssocID = self.AssocId
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func DeleteAssociation(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("supprimer") {
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.request.request(type: "DELETE", param: self.param,add: "associations/"+self.AssocId, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    
                }
            });
        }
        alertView.addButton("annuler") {
            
        }
        alertView.showError("Supprimer", subTitle: "Vous souhaitez supprimer votre association ?")
        
       

    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            
            if(segue.identifier == "createshelter"){
                let secondViewController = segue.destination as! CreateShelterViewController
                
                print("asso ID = \(Asso["id"])")
                secondViewController.AssocID = String(describing: Asso["id"])
                secondViewController.create = true
                
            }
            if(segue.identifier == "goToNotifAsso"){
                let secondViewController = segue.destination as! NotifAssociation

                print("asso ID = \(Asso["id"])")
                secondViewController.AssocID = String(describing: Asso["id"])
    
            }
            if(segue.identifier == "goToInviteMember"){
                let secondViewController = segue.destination as! InviteMemberController
                secondViewController.AssocID = String(describing: Asso["id"])
            }
            if(segue.identifier == "goToParamAsso"){
                let secondViewController = segue.destination as! ParametreAssociations
                secondViewController.Asso = Asso
                secondViewController.AssocId = self.AssocId
                
            }
            if(segue.identifier == "fromasso"){
                let secondViewController = segue.destination as! ManagePhotoController
                secondViewController.from = "2"
                secondViewController.id_asso = String(describing: Asso["id"])
                secondViewController.state = "true"
                
            }
        }
    
    @IBAction func unwindToEndCreateEvent(_ unwindSegue:UIStoryboardSegue) {
        //if let _ = unwindSegue.sourceViewController as? MenuOwnerAssocation {
            //performSegueWithIdentifier("BackToMenuVC", sender: self)}
        let data = unwindSegue.source as? DateCreateEvent
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        param["assoc_id"] = String(describing: Asso["id"])
        param["title"] = data?.eventTitle
        param["description"] = data?.descp
        param["place"] = data?.city
        param["begin"] = data?.start
        param["end"] = data?.end
        param["private"] = data?.state
        let val = "events"
        request.request(type: "POST", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
               // self.notifs = User
                //self.notifs_list.reloadData()
                if User["status"] == 200 {
                    SCLAlertView().showSuccess("Succès", subTitle: "Votre évènement a bien été créer !")
                }
                else {
                    SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                }
            }
            else {
                
            }
        });

        
       // _ = unwindSegue.sourceViewControllers
    }
    
    @IBAction func unwindToMenuOwner(_ sender: UIStoryboardSegue) {
        _ = sender.source
    }

}
