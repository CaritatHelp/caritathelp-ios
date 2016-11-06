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

        let val = "associations/" + AssoID + "/members"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User["response"]
                self.friends_list.reloadData()
                
            }
            else {
                
            }
        });
        
    }
    
    @IBAction func InviteMember(_ sender: AnyObject) {
        var i = 0
        
        while i < friends.count {
            //let rowToSelect:IndexPath = IndexPath(forRow: i, inSection: 0)
            let cell = friends_list.cellForRow(at: sender.indexPath as IndexPath)
            
            if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
                print("invite" + String(describing: friends[i]["firstname"]))
                
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                self.param["volunteer_id"] = String(describing: friends[i]["id"])
                self.param["event_id"] = EventID
                let val = "guests/invite"
                self.request.request(type: "POST", param: self.param,add: val, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        print("membre inviter : " + String(describing: self.friends[i]["firstname"]))
                    }
                    else {
                        print("n'a pas pu etre inviter")
                    }
                });
                
                
            }
            i += 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellInviteGuest  = friends_list.dequeueReusableCell(withIdentifier: "GuestCell", for: indexPath as IndexPath) as! CustomCellInviteGuest

        let name = String(describing: friends[indexPath.row]["firstname"]) + " " + String(describing: friends[indexPath.row]["lastname"])
        cell.setCell(NameLabel: name, imageName: define.path_picture + String(describing: friends[indexPath.row]["thumb_path"]))
        
        
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let cell = friends_list.cellForRow(at: indexPath as IndexPath)
        
        if (cell?.accessoryType == .checkmark){
            cell!.accessoryType = .none;
            
        }else{
            cell!.accessoryType = .checkmark;
            
        }
    }
}
