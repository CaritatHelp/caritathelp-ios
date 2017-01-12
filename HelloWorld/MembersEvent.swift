//
//  MembersEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 17/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class MembersEventController: UIViewController {
    
    //variable utilisé dans cette classe
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var EventID : String = ""
    var AssoID : String = ""
    var members : JSON = []
    var status = ""
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MyAssociations.loadDataFirstView), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    //variable en lien avec la storyBoard
    @IBOutlet weak var members_list: UITableView!
    @IBOutlet weak var manageMemberEvent: UIBarButtonItem!
    

    // init le tableview
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellEventMember = members_list.dequeueReusableCell(withIdentifier: "MemberEventCell", for: indexPath as IndexPath) as! CustomCellEventMember
        
        let nom = String(describing: members[indexPath.row]["firstname"]) + " " + String(describing: members[indexPath.row]["lastname"])
        cell.setCell(NameLabel: nom, DetailLabel: String(describing: members[indexPath.row]["rights"]), imageName: define.path_picture + String(describing: members[indexPath.row]["thumb_path"]))
        return cell
    }
    //nombre de ligne du table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    // bouton quand on slide une ligne du tableview
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //Bouton pour kick un membre de l'event
        let kickButton = UITableViewRowAction(style: .normal, title: "kick") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.param["volunteer_id"] = String(describing: self.members[indexPath.row]["id"])
            self.param["event_id"] = self.EventID
            let val = "guests/kick"
            self.request.request(type: "DELETE", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        SCLAlertView().showSuccess("Succès", subTitle: String(describing: User["message"]))
                        self.refresh()
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            });

        }
        
        //Bouton pour ajouter un ami
        let AddFriend = UITableViewRowAction(style: .normal, title: "Ajouter\nen ami") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            self.param["volunteer_id"] = String(describing: self.members[indexPath.row]["id"])
            let val = "friendship/add"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        SCLAlertView().showSuccess("Succès", subTitle: String(describing: User["message"]))
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            });
        }
        
        //Bouton pour modifier les droits
        let ModifyRights = UITableViewRowAction(style: .normal, title: "Modifier\nles droits") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            var rights = ""
            var rightsTexte = ""
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.param["volunteer_id"] = String(describing: self.members[indexPath.row]["id"])
            self.param["event_id"] = self.EventID
            if String(describing: self.members[indexPath.row]["rights"]) == "admin" {
                rights = "member"
                rightsTexte = "membre"
            }
            else if String(describing: self.members[indexPath.row]["rights"]) == "member" {
                rights = "admin"
                rightsTexte = "administrateur"
            }
            self.param["rights"] = rights
            let val = "guests/upgrade"
            self.request.request(type: "PUT", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    print(User["status"])
                    if User["status"] == 200 {
                        print("here")
                        let message = String(describing: self.members[indexPath.row]["fullname"]) + " a maintenant les droits: " + rightsTexte
                        SCLAlertView().showSuccess("Succès", subTitle: message)
                        //self.members[indexPath.row]["rights"] as String = rights
                        // update user
                        self.refresh()
                        self.members_list.reloadData()
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            })
        }

        //couleur des boutons
        AddFriend.backgroundColor = UIColor.GreenBasicCaritathelp()
        //shareAction.backgroundColor = UIColor(patternImage: UIImage(named: "add_user")!)
        kickButton.backgroundColor = UIColor.red
        
        if self.status == "host" || self.status == "admin" {
            return [AddFriend, kickButton, ModifyRights]
        }else {
            return [AddFriend]
        }
    }
    
    @IBAction func ManageMember(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("inviter") {
            let controller = InviteGuestController()
            controller.EventID = self.EventID
            controller.AssoID = self.AssoID
            self.navigationController?.pushViewController(controller, animated: true)
        }
        alertView.addButton("gérer mes invitations") {
            let controller = ManageDemandViewController()
            controller.EventID = self.EventID
            controller.from = "event"
            self.navigationController?.pushViewController(controller, animated: true)
        }
        alertView.addButton("annuler") {
            
        }
        alertView.showSuccess("Invitations", subTitle: "Que souhaitez-vous faire?")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        // get a reference to the second view controller
//        if(segue.identifier == "goToInviteGuest"){
//            let secondViewController = segue.destination as! InviteGuestController
//            
//            // set a variable in the second view controller with the String to pass
//            
//            secondViewController.EventID = EventID
//            secondViewController.AssoID = AssoID
//        }
//        
//    }


    //init les données au chargement de la vue
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        
        self.refresh()
    }
    
    func refresh() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "events/" + EventID + "/guests"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.members = User["response"]
                self.members_list.reloadData()
            }
            else {
                
            }
        });
    }

}
