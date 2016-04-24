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
    var members : JSON = []
    
    //variable en lien avec la storyBoard
    @IBOutlet weak var members_list: UITableView!
    
    // init le tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellEventMember = members_list.dequeueReusableCellWithIdentifier("MemberEventCell", forIndexPath: indexPath) as! CustomCellEventMember
        
        let nom = String(members["response"][indexPath.row]["firstname"]) + " " + String(members["response"][indexPath.row]["lastname"])
        cell.setCell(nom, DetailLabel: "8 amis en commun", imageName: "")
        return cell
    }
    //nombre de ligne du table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return members["response"].count
    }
    
    // bouton quand on slide une ligne du tableview
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        //Bouton pour kick un membre de l'event
        let shareAction2 = UITableViewRowAction(style: .Normal, title: "kick") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
        }
        //Bouton pour ajouter un ami
        let shareAction = UITableViewRowAction(style: .Normal, title: "Ajouter en ami") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.param["token"] = String(self.user["token"])
            self.param["volunteer_id"] = String(self.members["response"][indexPath.row]["id"])
            let val = "friendship/add"
            self.request.request("POST", param: self.param,add: val, callback: {
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
        shareAction.backgroundColor = UIColor.greenColor()
        //shareAction.backgroundColor = UIColor(patternImage: UIImage(named: "add_user")!)
        shareAction2.backgroundColor = UIColor.redColor()
        
        return [shareAction, shareAction2]
        
    }

    //init les données au chargement de la vue
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "events/" + EventID + "/guests"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.members = User
                self.members_list.reloadData()
            }
            else {
                
            }
        });
        
        
    }

}