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
        refreshControl.addTarget(self, action: #selector(VolunteerNotificationController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()

    @IBOutlet weak var list_notif: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : CustomCellNotif!
        let message = MessageNotif(indexPath.row)
        switch notifs["response"][indexPath.row]["notif_type"] {
        case "JoinAssoc", "InviteMember":
        cell = list_notif.dequeueReusableCellWithIdentifier("NotifCell", forIndexPath: indexPath) as! CustomCellNotif
        
        cell.setCell(message, DetailLabel: String(notifs["response"][indexPath.row]["created_at"]), imageName: define.path_picture + String(notifs["response"][indexPath.row]["thumb_path"]))
        case "JoinEvent", "InviteGuest":
        cell = list_notif.dequeueReusableCellWithIdentifier("NotifCell2", forIndexPath: indexPath) as! CustomCellNotif
            
            //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
            cell.setCell(message, DetailLabel: String(notifs["response"][indexPath.row]["created_at"]), imageName: define.path_picture + String(notifs["response"][indexPath.row]["thumb_path"]))
        default :
            print(notifs["response"][indexPath.row]["notif_type"])
            cell = list_notif.dequeueReusableCellWithIdentifier("NotifCell3", forIndexPath: indexPath) as! CustomCellNotif
            
            //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
            cell.setCell(message, DetailLabel: String(notifs["response"][indexPath.row]["created_at"]), imageName: define.path_picture + String(notifs["response"][indexPath.row]["thumb_path"]))
        }
        return cell
    }
    
    func MessageNotif(row: Int) -> String{
        var message = ""
        switch notifs["response"][row]["notif_type"] {
        case "JoinAssoc":
            message = String(notifs["response"][row]["sender_name"]) + " veux rejoindre votre association : " + String(notifs["response"][row]["assoc_name"])
        case "JoinEvent":
            message = String(notifs["response"][row]["sender_name"]) + " veux rejoindre votre évènement : " + String(notifs["response"][row]["event_name"])
        case "InviteMember":
            message = String(notifs["response"][row]["sender_name"]) + " vous invite à rejoindre l'association : " + String(notifs["response"][row]["assoc_name"])
        case "InviteGuest":
            message = String(notifs[row]["sender_name"]) + " vous invite à rejoindre l'évènement : " + String(notifs["response"][row]["event_name"])
        case "AddFriend":
            message = String(notifs["response"][row]["sender_name"]) + " veux vous ajouter en ami "
        case "NewGuest":
            message = String(notifs["response"][row]["sender_name"]) + " a rejoint l'association : " + String(notifs["response"][row]["assoc_name"])
        case "NewMember":
            message = String(notifs["response"][row]["sender_name"]) + " a rejoint l'association : " + String(notifs["response"][row]["assoc_name"])
        default:
            message = "erreur...."
        }
        return message
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifs["response"].count
    }

    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: (UITableViewRowAction, NSIndexPath) -> Void))
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Confirmer") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            print(String(self.notifs["response"][indexPath.row]["notif_type"]))
            self.param["token"] = String(self.user["token"])
            self.param["notif_id"] = String(self.notifs["response"][indexPath!.row]["id"])
            self.param["acceptance"] = "true"
            var val = ""
            if self.notifs["response"][indexPath.row]["notif_type"] == "AddFriend" {
                val = "friendship/reply"
            }
            else if self.notifs["response"][indexPath.row]["notif_type"] == "InviteMember" {
                val = "membership/reply_invite"
            }else if self.notifs["response"][indexPath.row]["notif_type"] == "InviteGuest" {
                val = "guests/reply_invite"
            }
            else if self.notifs["response"][indexPath.row]["notif_type"] == "JoinAssoc" {
                val = "membership/reply_member"
            }else if self.notifs["response"][indexPath.row]["notif_type"] == "JoinEvent" {
                val = "guests/reply_guest"
            }
            self.request.request("POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                   self.refresh()
                }
                else {
                    
                }
            });
            
        }
        let shareAction2 = UITableViewRowAction(style: .Normal, title: "refuser") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            self.param["token"] = String(self.user["token"])
            self.param["notif_id"] = String(self.notifs["response"][indexPath!.row]["id"])
            self.param["acceptance"] = "false"
            var val = ""
            if self.notifs["response"][indexPath.row]["notif_type"] == "AddFriend" {
                val = "friendship/reply"
            }
            else if self.notifs["response"][indexPath.row]["notif_type"] == "InviteMember" {
                val = "membership/reply_invite"
            }else if self.notifs["response"][indexPath.row]["notif_type"] == "InviteGuest" {
                val = "guests/reply_invite"
            }else if self.notifs["response"][indexPath.row]["notif_type"] == "JoinAssoc" {
                val = "membership/reply_member"
            }else if self.notifs["response"][indexPath.row]["notif_type"] == "JoinEvent" {
                val = "guests/reply_guest"
            }
            self.request.request("POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.refresh()
                }
                else {
                    
                }
            });
            
        }
        shareAction2.backgroundColor = UIColor.redColor()
        shareAction.backgroundColor = UIColor(red: 50.0/255, green: 150.0/255, blue: 65.0/255, alpha: 1.0)
        return [shareAction2, shareAction]
        
    }

    override func viewWillAppear(animated: Bool) {
        let tabController = UIApplication.sharedApplication().windows.first?.rootViewController as? UITabBarController
        let tabArray = tabController!.tabBar.items as NSArray!
        let alertTabItem = tabArray.objectAtIndex(2) as! UITabBarItem
        
        
        if let badgeValue = (alertTabItem.badgeValue) {
            let intValue = Int(badgeValue)
            alertTabItem.badgeValue = (intValue! + 1).description
            print(intValue)
        } else {
            alertTabItem.badgeValue = "1"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list_notif.tableFooterView = UIView()
        self.list_notif.addSubview(self.refreshControl)
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "/notifications"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.notifs = User
                self.list_notif.reloadData()
            }
            else {
                
            }
        });
        
    }
    
    
    
    func refresh() {
        // Code to refresh table view
        param["token"] = String(user["token"])
        let val = "notifications/"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.notifs = User
                self.list_notif.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                
            }
        });
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = list_notif.indexPathForCell(sender as! UITableViewCell)
        //        // get a reference to the second view controller
        if(segue.identifier == "fromnotiftoprofil"){
            let secondViewController = segue.destinationViewController as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = String(notifs["response"][indexPath!.row]["sender_id"])
        }
        if(segue.identifier == "fromnotiftoevent"){
            let secondViewController = segue.destinationViewController as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(notifs["response"][indexPath!.row]["event_id"])
        }
        if(segue.identifier == "fromnotiftoasso"){
            let secondViewController = segue.destinationViewController as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            secondViewController.AssocID = String(notifs["response"][indexPath!.row]["assoc_id"])
        }
    }

}

