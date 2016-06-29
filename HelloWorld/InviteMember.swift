//
//  InviteMember.swift
//  Caritathelp
//
//  Created by Jeremy gros on 23/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class InviteMemberController: UIViewController {
    
    var user : JSON = []
    var AssocID = ""
    var request = RequestModel()
    var param = [String: String]()
    var friends : JSON = []
    
    @IBOutlet weak var friends_list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends_list.tableFooterView = UIView()
        
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "volunteers/" + String(user["id"]) + "/friends"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User
                self.friends_list.reloadData()
                
            }
            else {
                
            }
        });

    }
    
    @IBAction func InviteMember(sender: AnyObject) {
        var i = 0
    
        while i < friends["response"].count {
            let rowToSelect:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell = friends_list.cellForRowAtIndexPath(rowToSelect)
            
            if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
                //print("invite" + String(friends["response"][i]["firstname"]))
                
                param["token"] = String(user["token"])
                param["volunteer_id"] = String(friends["response"][i]["id"])
                param["assoc_id"] = AssocID
                let val = "membership/invite"
                request.request("POST", param: param,add: val, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        print("membre inviter : " + String(self.friends["response"][i]["firstname"]))
                    }
                    else {
                        print("n'a pas pu etre inviter")
                    }
                });

                
            }
            i += 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellInviteMember  = friends_list.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! CustomCellInviteMember
        let name = String(friends["response"][indexPath.row]["firstname"]) + " " + String(friends["response"][indexPath.row]["lastname"])
        cell.setCell(name, imageName: define.path_picture + String(friends["response"][indexPath.row]["thumb_path"]))
        
        
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends["response"].count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let cell = friends_list.cellForRowAtIndexPath(indexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.None;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark;
            
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        
        let cell = friends_list.cellForRowAtIndexPath(indexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.None;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark;
            
        }
    }

    
}