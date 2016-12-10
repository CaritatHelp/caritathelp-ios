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

class InviteMemberController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user : JSON = []
    var AssocID = ""
    var request = RequestModel()
    var param = [String: String]()
    var friends : JSON = []
    
    @IBOutlet weak var friends_list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friends_list.tableFooterView = UIView()
        
        self.user = sharedInstance.volunteer["response"]
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "volunteers/" + String(describing: user["id"]) + "/friends"
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
            //let rowToSelect: IndexPath = IndexPath(forRow: i, inSection: 0) //NSIndexPath(forRow: i, inSection: 0)
            print("index : \(sender.indexPath)")
            let cell = friends_list.cellForRow(at: IndexPath(row: i, section: 0))
            
            if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
                //print("invite" + String(friends[i]["firstname"]))
                
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]

                param["volunteer_id"] = String(describing: friends[i]["id"])
                param["assoc_id"] = AssocID
                let val = "membership/invite"
                request.request(type: "POST", param: param,add: val, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        print("membre inviter : " + String(describing: self.friends[i]["firstname"]))
                        SCLAlertView().showSuccess("invitations envoyées", subTitle: "Vos invitations viennent d'être envoyer à vos amis pour rejoindre votre association.")
                    }
                    else {
                        SCLAlertView().showError("Invitations non envoyés", subTitle: "une invitation a déjà été envoyé.")
                        print("n'a pas pu etre inviter")
                    }
                });
            }
            i += 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell : CustomCellInviteMember  = friends_list.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath as IndexPath) as! CustomCellInviteMember
        let name = String(describing: friends[indexPath.row]["firstname"]) + " " + String(describing: friends[indexPath.row]["lastname"])
        cell.setCell(NameLabel: name, imageName: define.path_picture + String(describing: friends[indexPath.row]["thumb_path"]))
        
        
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = friends_list.cellForRow(at: indexPath as IndexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
        let cell = friends_list.cellForRow(at: indexPath as IndexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            
        }
    }

    
}
