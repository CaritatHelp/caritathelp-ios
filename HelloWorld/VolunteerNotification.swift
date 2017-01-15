//
//  VolunteerNotification.swift
//  Caritathelp
//
//  Created by Jeremy gros on 24/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class VolunteerNotificationController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var notifs : JSON = []
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(VolunteerNotificationController.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var list_notif: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : CustomCellNotif!
        let message = MessageNotif(row: indexPath.row)
        let date = String(describing: notifs[indexPath.row]["created_at"]).transformToDate() + " à " + String(describing: notifs[indexPath.row]["created_at"]).getHeureFromString()
        switch notifs[indexPath.row]["notif_type"] {
        case "JoinAssoc", "InviteMember":
            cell = list_notif.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as! CustomCellNotif
            
            cell.setCell(NameLabel: message, DetailLabel: date, imageName: define.path_picture + String(describing: notifs[indexPath.row]["sender_thumb_path"]))
        case "JoinEvent", "InviteGuest":
            cell = list_notif.dequeueReusableCell(withIdentifier: "NotifCell2", for: indexPath) as! CustomCellNotif
            
            //        cell.textLabel!.text = String(asso_list[indexPath.row]["name"])
            cell.setCell(NameLabel: message, DetailLabel: date, imageName: define.path_picture + String(describing: notifs[indexPath.row]["sender_thumb_path"]))
        default :
            print(notifs[indexPath.row]["notif_type"])
            cell = list_notif.dequeueReusableCell(withIdentifier: "NotifCell3", for: indexPath) as! CustomCellNotif
            
            //        cell.textLabel!.text = String(asso_list[indexPath.row]["name"])
            cell.setCell(NameLabel: message, DetailLabel: date, imageName: define.path_picture + String(describing: notifs[indexPath.row]["sender_thumb_path"]))
        }
        return cell
    }
    
    func MessageNotif(row: Int) -> String{
        var message = ""
        switch notifs[row]["notif_type"] {
        case "JoinAssoc":
            message = String(describing: notifs[row]["sender_name"]) + " veux rejoindre votre association : " + String(describing: notifs[row]["assoc_name"])
        case "JoinEvent":
            message = String(describing: notifs[row]["sender_name"]) + " veux rejoindre votre évènement : " + String(describing: notifs[row]["event_name"])
        case "InviteMember":
            message = String(describing: notifs[row]["sender_name"]) + " vous invite à rejoindre l'association : " + String(describing: notifs[row]["assoc_name"])
        case "InviteGuest":
            message = String(describing: notifs[row]["sender_name"]) + " vous invite à rejoindre l'évènement : " + String(describing: notifs[row]["event_name"])
        case "AddFriend":
            message = String(describing: notifs[row]["sender_name"]) + " veux vous ajouter en ami "
        case "NewGuest":
            message = String(describing: notifs[row]["sender_name"]) + " a rejoint l'association : " + String(describing: notifs[row]["assoc_name"])
        case "NewMember":
            message = String(describing: notifs[row]["sender_name"]) + " a rejoint l'association : " + String(describing: notifs[row]["assoc_name"])
        case "Emergency":
            message = "L'evènement " + String(describing: notifs[row]["event_name"]) + " a besoin de vous urgement !"
        case "AcceptedEmergency":
            message = " Vous participez à l'urgence de l'evènement " + String(describing: notifs[row]["event_name"])
        default:
            message = "erreur...."
        }
        return message
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notifs.count)
        return notifs.count
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: (UITableViewRowAction, NSIndexPath) -> Void))
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Confirmer") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            print(String(describing: self.notifs[indexPath.row]["notif_type"]))
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.param["notif_id"] = String(describing: self.notifs[indexPath!.row]["id"])
            self.param["acceptance"] = "true"
            var val = ""
            if self.notifs[indexPath.row]["notif_type"] == "AddFriend" {
                val = "friendship/reply"
            }
            else if self.notifs[indexPath.row]["notif_type"] == "InviteMember" {
                val = "membership/reply_invite"
            }else if self.notifs[indexPath.row]["notif_type"] == "InviteGuest" {
                val = "guests/reply_invite"
            }
            else if self.notifs[indexPath.row]["notif_type"] == "JoinAssoc" {
                val = "membership/reply_member"
            }else if self.notifs[indexPath.row]["notif_type"] == "JoinEvent" {
                val = "guests/reply_guest"
            }
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.refresh()
                }
                else {
                    
                }
            });
            
        }
        let shareAction2 = UITableViewRowAction(style: .normal, title: "refuser") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.param["notif_id"] = String(describing: self.notifs[indexPath!.row]["id"])
            self.param["acceptance"] = "false"
            var val = ""
            if self.notifs[indexPath.row]["notif_type"] == "AddFriend" {
                val = "friendship/reply"
            }
            else if self.notifs[indexPath.row]["notif_type"] == "InviteMember" {
                val = "membership/reply_invite"
            }else if self.notifs[indexPath.row]["notif_type"] == "InviteGuest" {
                val = "guests/reply_invite"
            }else if self.notifs[indexPath.row]["notif_type"] == "JoinAssoc" {
                val = "membership/reply_member"
            }else if self.notifs[indexPath.row]["notif_type"] == "JoinEvent" {
                val = "guests/reply_guest"
            }
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.refresh()
                }
                else {
                    
                }
            });
            
        }
        shareAction2.backgroundColor = UIColor.red
        shareAction.backgroundColor = UIColor(red: 50.0/255, green: 150.0/255, blue: 65.0/255, alpha: 1.0)
        return [shareAction2, shareAction]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list_notif.tableFooterView = UIView()
        self.list_notif.addSubview(self.refreshControl)
        user = sharedInstance.volunteer
        
        self.refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        let tabArray = tabController!.tabBar.items?[3] as UITabBarItem!
        tabArray?.badgeValue = nil
    }
    
    func refresh() {
        // Code to refresh table view
        print("avant")
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        print("avant 2")
        self.request.request(type: "GET", param: self.param, add: "notifications", callback: {
            (isOK, User)-> Void in
            if(isOK){
                print("SUCCESS")
                self.notifs = User["response"]
                self.list_notif.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                print("ERROR ...")
            }
        });
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = list_notif.indexPath(for: sender as! UITableViewCell)
        //        // get a reference to the second view controller
        if(segue.identifier == "fromnotiftoprofil"){
            let secondViewController = segue.destination as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = String(describing: notifs[indexPath!.row]["sender_id"])
        }
        if(segue.identifier == "fromnotiftoevent"){
            let secondViewController = segue.destination as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(describing: notifs[indexPath!.row]["event_id"])
        }
        if(segue.identifier == "fromnotiftoasso"){
            let secondViewController = segue.destination as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            secondViewController.AssocID = String(describing: notifs[indexPath!.row]["assoc_id"])
        }
    }
    
}

