//
//  InviteGuest.swift
//  Caritathelp
//
//  Created by Jeremy gros on 26/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class InviteGuestController: UIViewController {
    var user : JSON = []
    var EventID = ""
    var AssoID = ""
    var request = RequestModel()
    var param = [String: String]()
    var friends : JSON = []
    
    @IBOutlet weak var friends_list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends_list.tableFooterView = UIView()
        
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        param["token"] = String(describing: user["token"])
        let val = "associations/" + AssoID + "/members"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User
                self.friends_list.reloadData()
                
            }
            else {
                
            }
        });
        
    }
    
    @IBAction func InviteMember(_ sender: AnyObject) {
        var i = 0
        
        while i < friends["response"].count {
            //let rowToSelect:IndexPath = IndexPath(forRow: i, inSection: 0)
            let cell = friends_list.cellForRow(at: sender.indexPath as IndexPath)
            
            if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
                print("invite" + String(describing: friends["response"][i]["firstname"]))
                
//                param["token"] = String(user["token"])
//                param["volunteer_id"] = String(friends["response"][i]["id"])
//                param["assoc_id"] = EventID
//                let val = "guests/invite"
//                request.request("GET", param: param,add: val, callback: {
//                    (isOK, User)-> Void in
//                    if(isOK){
//                        print("membre inviter : " + String(self.friends["response"][i]["firstname"]))
//                    }
//                    else {
//                        print("n'a pas pu etre inviter")
//                    }
//                });
                
                
            }
            i += 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellInviteGuest  = friends_list.dequeueReusableCell(withIdentifier: "GuestCell", for: indexPath as IndexPath) as! CustomCellInviteGuest

        let name = String(describing: friends["response"][indexPath.row]["firstname"]) + " " + String(describing: friends["response"][indexPath.row]["lastname"])
        cell.setCell(NameLabel: name, imageName: define.path_picture + String(describing: friends["response"][indexPath.row]["thumb_path"]))
        
        
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends["response"].count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let cell = friends_list.cellForRow(at: indexPath as IndexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        
        let cell = friends_list.cellForRow(at: indexPath as IndexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            
        }
    }
}
