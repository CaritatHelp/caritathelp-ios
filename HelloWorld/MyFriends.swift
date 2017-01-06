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

class MyFriendsController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friends : JSON = []
    var friends_request : JSON = []
    var user : JSON = []
    var param = [String: String]()
    var request = RequestModel()
    var fromProfil = false
    var idfriend = ""
    
    
    @IBOutlet weak var list_friends: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomFriendsCell = list_friends.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath as IndexPath) as! CustomFriendsCell
        if indexPath.section == 0  && fromProfil == false{
            let name = String(describing: friends_request[indexPath.row]["firstname"]) + " " + String(describing: friends_request[indexPath.row]["lastname"])
            cell.setCell(NameLabel: name, DetailLabel: "", imageName:  define.path_picture + String(describing: friends[indexPath.row]["thumb_path"]))

        } else {
        let name = String(describing: friends[indexPath.row]["firstname"]) + " " + String(describing: friends[indexPath.row]["lastname"])
        cell.setCell(NameLabel: name, DetailLabel: String(describing: friends[indexPath.row]["nb_common_friends"]) + " amis en commun", imageName: define.path_picture + String(describing: friends[indexPath.row]["thumb_path"]))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width: list_friends.bounds.size.width,height: list_friends.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = .center
        
        if(friends.count == 0){
            noDataLabel.text = "Vous n'avez aucun ami... \n BOLOSS"
        }
        else{
            noDataLabel.text = ""
        }
        list_friends.backgroundView = noDataLabel
        
        var count = 0
        
        if section == 0 && fromProfil == false{
            count = friends_request.count
        }else {
            count = friends.count
        }
        return count
    }
    
   func numberOfSections(in tableView: UITableView) -> Int {
        var NbSection = 1
        if fromProfil == false {
            NbSection = 2
        }
        return NbSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title_tab = ["Invitation envoyées","Vos amis"]
        if fromProfil == true {
            title_tab = ["Amis"]
        }
        return title_tab[section]
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 && fromProfil == false{
        let shareAction2 = UITableViewRowAction(style: .normal, title: "annuler") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            self.param["notif_id"] = String(describing: self.friends_request[indexPath!.row]["notif_id"])
            self.request.request(type: "DELETE", param: self.param,add: "friendship/cancel_request", callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.refresh()
                }
                else {
                    
                }
            });
            
        }
        shareAction2.backgroundColor = UIColor.red
        return [shareAction2]
        }
        else {
            if !fromProfil {
            let shareAction2 = UITableViewRowAction(style: .normal, title: "Supprimer cet ami") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
                
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                
                self.param["volunteer_id"] = String(describing: self.friends[indexPath!.row]["id"])
                self.request.request(type: "DELETE", param: self.param,add: "friendship/remove", callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.refresh()
                    }
                    else {
                        
                    }
                });
                
            }
            shareAction2.backgroundColor = UIColor.red
            return [shareAction2]
            }
            else {
                return []
            }
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list_friends.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        refresh()
    }
    
    func refresh(){
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        var val = ""
        if fromProfil == false {
            val = "volunteers/" + String(describing: user["id"]) + "/friends"
        }else {
            val = "volunteers/" + idfriend + "/friends"
        }
        self.request.request(type: "GET", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User["response"]
                self.param["sent"] = "true"
                self.request.request(type: "GET", param: self.param,add: "friend_requests", callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.friends_request = User["response"]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "ProfilFriend"){
            let indexPath = list_friends.indexPath(for: sender as! UITableViewCell)
            
            let secondViewController = segue.destination as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            if indexPath!.section == 0 && fromProfil == false{
                secondViewController.idvolunteer = String(describing: friends_request[indexPath!.row]["id"])
            }else {
                secondViewController.idvolunteer = String(describing: friends[indexPath!.row]["id"])
            }
        }
        
    }
}
