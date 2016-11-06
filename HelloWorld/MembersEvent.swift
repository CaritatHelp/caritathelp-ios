//
//  MembersEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 17/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MembersEventController: UIViewController {
    
    //variable utilisé dans cette classe
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var EventID : String = ""
    var AssoID : String = ""
    var members : JSON = []
    
    //variable en lien avec la storyBoard
    @IBOutlet weak var members_list: UITableView!
    
    // init le tableview
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellEventMember = members_list.dequeueReusableCell(withIdentifier: "MemberEventCell", for: indexPath as IndexPath) as! CustomCellEventMember
        
        let nom = String(describing: members[indexPath.row]["firstname"]) + " " + String(describing: members[indexPath.row]["lastname"])
        cell.setCell(NameLabel: nom, DetailLabel: "8 amis en commun", imageName: define.path_picture + String(describing: members[indexPath.row]["thumb_path"]))
        return cell
    }
    //nombre de ligne du table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    // bouton quand on slide une ligne du tableview
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        //Bouton pour kick un membre de l'event
        let shareAction2 = UITableViewRowAction(style: .normal, title: "kick") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
        }
        //Bouton pour ajouter un ami
        let shareAction = UITableViewRowAction(style: .normal, title: "Ajouter en ami") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            self.param["volunteer_id"] = String(describing: self.members[indexPath.row]["id"])
            let val = "friendship/add"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    //self.friends = User
                    //self.list_friends.reloadData()
                }
                else {
                    
                }
            });

        }
        //couleur des boutons
        shareAction.backgroundColor = UIColor.green
        //shareAction.backgroundColor = UIColor(patternImage: UIImage(named: "add_user")!)
        shareAction2.backgroundColor = UIColor.red
         return [shareAction, shareAction2]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "goToInviteGuest"){
            let secondViewController = segue.destination as! InviteGuestController
            
            // set a variable in the second view controller with the String to pass
            
            secondViewController.EventID = EventID
            secondViewController.AssoID = AssoID
        }
        
    }


    //init les données au chargement de la vue
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "events/" + EventID + "/guests"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.members = User["response"]
                self.members_list.reloadData()
            }
            else {
                
            }
        });
        
        
    }

}
