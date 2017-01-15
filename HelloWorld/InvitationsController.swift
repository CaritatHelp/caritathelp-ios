//
//  InvitationsController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 23/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class InvitationsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var InvitsAssoBtn: UIBarButtonItem!
    @IBOutlet weak var InvitsEventBtn: UIBarButtonItem!
    @IBOutlet weak var InvitsFriendBtn: UIBarButtonItem!
    @IBOutlet weak var list_invits: UITableView!
    var user : JSON = []
    var invits : JSON = []
    var invits_asso :JSON = []
    var invits_event : JSON = []
    var invits_friend : JSON = []
    var request = RequestModel()
    var param = [String: Any]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(VolunteerNotificationController.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        list_invits.tableFooterView = UIView()
        self.list_invits.addSubview(self.refreshControl)
        InvitsAssoBtn.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        user = sharedInstance.volunteer["response"]
        self.refresh()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : CustomCellInvits!
        let message = MessageNotif(row: indexPath.row)
        let imagePath = define.path_picture + String(describing: invits[indexPath.row]["sender_thumb_path"])
        print("image :::: " + imagePath)
        switch invits[indexPath.row]["notif_type"] {
        case "InviteMember":
            cell = list_invits.dequeueReusableCell(withIdentifier: "CellInvitation", for: indexPath) as! CustomCellInvits
            
            cell.setCell(NameLabel: message, DetailLabel: String(describing: invits[indexPath.row]["created_at"]), imageName: imagePath)
        case "InviteGuest":
            cell = list_invits.dequeueReusableCell(withIdentifier: "CellInvitation2", for: indexPath) as! CustomCellInvits
            
            //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
            cell.setCell(NameLabel: message, DetailLabel: String(describing: invits[indexPath.row]["created_at"]), imageName: imagePath)
        default :
            print(invits["notif_type"])
            cell = list_invits.dequeueReusableCell(withIdentifier: "CellInvitation3", for: indexPath) as! CustomCellInvits
            
            //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
            cell.setCell(NameLabel: message, DetailLabel: String(describing: invits[indexPath.row]["created_at"]), imageName: imagePath)
        }
        return cell
    }
    
    func MessageNotif(row: Int) -> String{
        var message = ""
        switch invits[row]["notif_type"] {
        case "InviteMember":
            message = String(describing: invits[row]["sender_name"]) + " vous invite à rejoindre l'association : " + String(describing: invits[row]["assoc_name"])
        case "InviteGuest":
            message = String(describing: invits[row]["sender_name"]) + " vous invite à rejoindre l'évènement : " + String(describing: invits[row]["event_name"])
        case "AddFriend":
            message = String(describing: invits[row]["sender_name"]) + " veux vous ajouter en ami "
        default:
            message = "erreur...."
        }
        return message
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invits.count
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: (UITableViewRowAction, NSIndexPath) -> Void))
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Confirmer") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            self.param["notif_id"] = String(describing: self.invits[indexPath!.row]["id"])
            self.param["acceptance"] = true
            //print(self.param["notif_id"])
            var val = ""
            if self.invits[indexPath.row]["notif_type"] == "AddFriend" {
                val = "friendship/reply"
            }
            else if self.invits[indexPath.row]["notif_type"] == "InviteMember" {
                val = "membership/reply_invite"
            }else if self.invits[indexPath.row]["notif_type"] == "InviteGuest" {
                val = "guests/reply_invite"
            }
            print("val = = \(val)")
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
            
            print("nouvel ami !")
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            self.param["notif_id"] = String(describing: self.invits[indexPath!.row]["id"])
            self.param["acceptance"] = false
            var val = ""
            if self.invits[indexPath.row]["notif_type"] == "AddFriend" {
                val = "friendship/reply"
            }
            else if self.invits[indexPath.row]["notif_type"] == "InviteMember" {
                val = "membership/reply_invite"
            }else if self.invits[indexPath.row]["notif_type"] == "InviteGuest" {
                val = "guests/reply_invite"
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

    @IBAction func ShowInvitsAsso(_ sender: AnyObject) {
        InvitsAssoBtn.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        InvitsEventBtn.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        InvitsFriendBtn.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        invits = invits_asso
        //nb_past = events_past.count
        //index = 0
        list_invits.reloadData()
    }
    
    @IBAction func ShowInvitsEvent(_ sender: AnyObject) {
        InvitsEventBtn.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        InvitsAssoBtn.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        InvitsFriendBtn.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        invits = invits_event
        //nb_past = events_past.count
        //index = 0
        list_invits.reloadData()
    }
    
    @IBAction func ShowInvitsFriend(_ sender: AnyObject) {
        InvitsFriendBtn.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        InvitsEventBtn.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        InvitsAssoBtn.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        invits = invits_friend
        //nb_past = events_past.count
        //index = 0
        list_invits.reloadData()
    }
    
    func refresh() {
        // Code to refresh table view
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "notifications/"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                var TableData:Array< JSON > = Array < JSON >()
                var TableData2:Array< JSON > = Array < JSON >()
                var TableData3:Array< JSON > = Array < JSON >()
                //let dateFormatter = NSDateFormatter()
                let total = User["response"].count
                var i = 0
                while i < total{
                    if User["response"][i]["notif_type"] == "InviteMember"  {
                        TableData.append(User["response"][i])
                    }else if User["response"][i]["notif_type"] == "InviteGuest"{
                        TableData2.append(User["response"][i])
                    }
                    else if User["response"][i]["notif_type"] == "AddFriend"{
                        print("entrer !!!!!")
                        TableData3.append(User["response"][i])
                    }
                    i += 1
                }
                self.invits_asso = JSON(TableData)
                self.invits_event = JSON(TableData2)
                self.invits_friend = JSON(TableData3)
                self.invits = self.invits_asso
                //self.nb_futur = self.events.count
                
                //self.invits = User
                self.list_invits.reloadData()
            }
            else {
                
            }
        });
    }
    
}
