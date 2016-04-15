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

    
    @IBOutlet weak var list_notif: UITableView!
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellNotif = list_notif.dequeueReusableCellWithIdentifier("NotifCell", forIndexPath: indexPath) as! CustomCellNotif
        
        //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
       let name = "Demande d'ami de " + String(notifs["response"]["add_friend"][indexPath.row]["firstname"]) + " " + String(notifs["response"]["add_friend"][indexPath.row]["lastname"])
        cell.setCell(name, DetailLabel: "", imageName: "")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifs["response"]["add_friend"].count
    }

    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: (UITableViewRowAction, NSIndexPath) -> Void))
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Confirmer") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            print("nouvel ami !")
            self.param["token"] = String(self.user["token"])
            self.param["notif_id"] = String(self.notifs["response"]["add_friend"][indexPath!.row]["notif_id"])
            self.param["acceptance"] = "true"
            //print(self.param["notif_id"])
            let val = "friendship/reply"
            self.request.request("POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    //self.asso_list = User
                    self.list_notif.reloadData()
                }
                else {
                    
                }
            });
            
            
            
        }
        
        shareAction.backgroundColor = UIColor.greenColor()
        
        return [shareAction]
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "volunteers/" + String(user["id"]) + "/notifications"
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
}