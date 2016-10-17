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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notifs_list.dequeueReusableCell(withIdentifier: "NotifAssoCell", for: indexPath as IndexPath)
        
        cell.textLabel!.text = String(describing: notifs["member_request"][indexPath.row]["firstname"]) + " " + String(describing: notifs["member_request"][indexPath.row]["lastname"])
        cell.detailTextLabel?.text = "demande de membre"
        print("res : ")
        print(String(describing: notifs["member_request"]))
        print("fin .")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return notifs.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "associations/" + AssocID + "/notifications"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.notifs = User["response"]
                self.notifs_list.reloadData()
            }
            else {
                
            }
        });
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: <#T##(UITableViewRowAction, NSIndexPath) -> Void#>))
        let shareAction2 = UITableViewRowAction(style: .normal, title: "Refuser") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
        }
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Accepter") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            self.param["notif_id"] = String(describing: self.notifs["member_request"][indexPath.row]["notif_id"])
            self.param["acceptance"] = "true"
            let val = "/membership/reply_member"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.param["token"] = String(describing: self.user["token"])
                    let val = "associations/" + self.AssocID + "/notifications"
                    self.request.request(type: "GET", param: self.param,add: val, callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            self.notifs = User["response"]
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
        

        
        shareAction.backgroundColor = UIColor.green
        shareAction2.backgroundColor = UIColor.red
        
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
    //            secondViewController.AssocID = String(asso_list[indexPath!.row]["id"])
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
