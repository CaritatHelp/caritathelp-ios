//
//  NotifAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 25/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class NotifAssociation : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user : JSON = []
    var AssocID = ""
    var request = RequestModel()
    var param = [String: String]()
    var notifs : JSON = []
    

    @IBOutlet weak var notifs_list: UITableView!
    
    //let AssocList = ["la croix rouge", "les restos du coeur", "futsal"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = notifs_list.dequeueReusableCellWithIdentifier("NotifAssoCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = String(notifs["response"]["member_request"][indexPath.row]["firstname"]) + " " + String(notifs["response"]["member_request"][indexPath.row]["lastname"])
        cell.detailTextLabel?.text = "demande de membre"
        print("res : ")
        print(String(notifs["response"]["member_request"]))
        print("fin .")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return notifs["response"].count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "associations/" + AssocID + "/notifications"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.notifs = User
                self.notifs_list.reloadData()
            }
            else {
                
            }
        });
        
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: <#T##(UITableViewRowAction, NSIndexPath) -> Void#>))
        let shareAction2 = UITableViewRowAction(style: .Normal, title: "Refuser") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
        }
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Accepter") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            self.param["token"] = String(self.user["token"])
            self.param["notif_id"] = String(self.notifs["response"]["member_request"][indexPath.row]["notif_id"])
            self.param["acceptance"] = "true"
            let val = "/membership/reply_member"
            self.request.request("POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.param["token"] = String(self.user["token"])
                    let val = "associations/" + self.AssocID + "/notifications"
                    self.request.request("GET", param: self.param,add: val, callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            self.notifs = User
                            self.notifs_list.reloadData()
                        }
                        else {
                            
                        }
                    });

                    
                }
                else {
                    
                }
            });
        }
        

        
        shareAction.backgroundColor = UIColor.greenColor()
        shareAction2.backgroundColor = UIColor.redColor()
        
        return [shareAction, shareAction2]
        
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        // get a reference to the second view controller
    //        if(segue.identifier == "AssocProfilVC2"){
    //            let indexPath = members_list.indexPathForCell(sender as! UITableViewCell)
    //            let currentCell = members_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
    //
    //
    //
    //            let secondViewController = segue.destinationViewController as! AssociationProfil
    //
    //            // set a variable in the second view controller with the String to pass
    //            secondViewController.TitleAssoc = currentCell.textLabel!.text!
    //            secondViewController.AssocID = String(asso_list["response"][indexPath!.row]["id"])
    //            secondViewController.user = user
    //            print(indexPath?.row);
    //            navigationItem.title = "back"
    //        }
    //        if(segue.identifier == "CreateAssocSeg"){
    //            let secondViewController = segue.destinationViewController as! NewAssociation
    //
    //            // set a variable in the second view controller with the String to pass
    //            secondViewController.user = user
    //            
    //        }
    //        
    //    }

}
