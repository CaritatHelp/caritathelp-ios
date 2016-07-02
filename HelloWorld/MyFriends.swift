//
//  MyFriends.swift
//  Caritathelp
//
//  Created by Jeremy gros on 24/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyFriendsController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var friends : JSON = []
    var friends_request : JSON = []
    var user : JSON = []
    var param = [String: String]()
    var request = RequestModel()
    var fromProfil = false
    var idfriend = ""
    
    
    @IBOutlet weak var list_friends: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomFriendsCell = list_friends.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! CustomFriendsCell
        if indexPath.section == 0  && fromProfil == false{
            let name = String(friends_request["response"][indexPath.row]["firstname"]) + " " + String(friends_request["response"][indexPath.row]["lastname"])
            cell.setCell(name, DetailLabel: "", imageName:  define.path_picture + String(friends["response"][indexPath.row]["thumb_path"]))

        } else {
        let name = String(friends["response"][indexPath.row]["firstname"]) + " " + String(friends["response"][indexPath.row]["lastname"])
        cell.setCell(name, DetailLabel: String(friends["response"][indexPath.row]["nb_common_friends"]) + " amis en commun", imageName: define.path_picture + String(friends["response"][indexPath.row]["thumb_path"]))
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, list_friends.bounds.size.width, list_friends.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.Center
        
        if(friends["response"].count == 0){
            noDataLabel.text = "Vous n'avez aucun ami... \n BOLOSS"
        }
        else{
            noDataLabel.text = ""
        }
        list_friends.backgroundView = noDataLabel
        
        var count = 0
        
        if section == 0 && fromProfil == false{
            count = friends_request["response"].count
        }else {
            count = friends["response"].count
        }
        return count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var NbSection = 1
        if fromProfil == false {
            NbSection = 2
        }
        return NbSection
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title_tab = ["Invitation envoyées","Vos amis"]
        if fromProfil == true {
            title_tab = ["Amis"]
        }
        return title_tab[section]
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 && fromProfil == false{
        let shareAction2 = UITableViewRowAction(style: .Normal, title: "annuler") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            self.param["token"] = String(self.user["token"])
            self.param["notif_id"] = String(self.friends_request["response"][indexPath!.row]["notif_id"])
            self.param["acceptance"] = "false"
            self.request.request("POST", param: self.param,add: "friendship/reply", callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.refresh()
                }
                else {
                    
                }
            });
            
        }
        shareAction2.backgroundColor = UIColor.redColor()
        return [shareAction2]
        }
        else {
            return []
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list_friends.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        refresh()

    }
    
    func refresh(){
        param["token"] = String(user["token"])
        var val = ""
        if fromProfil == false {
            val = "volunteers/" + String(user["id"]) + "/friends"
        }else {
            val = "volunteers/" + idfriend + "/friends"
        }
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User
                self.param["token"] = String(self.user["token"])
                self.param["sent"] = "true"
                self.request.request("GET", param: self.param,add: "friend_requests", callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.friends_request = User
                        self.list_friends.reloadData()
                    }
                    else {
                        
                    }
                });
            }
            else {
                
            }
        });
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "ProfilFriend"){
            let indexPath = list_friends.indexPathForCell(sender as! UITableViewCell)
            
            let secondViewController = segue.destinationViewController as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            if indexPath!.section == 0 && fromProfil == false{
                secondViewController.idvolunteer = String(friends_request["response"][indexPath!.row]["id"])
            }else {
                secondViewController.idvolunteer = String(friends["response"][indexPath!.row]["id"])
            }
        }
        
    }
}
