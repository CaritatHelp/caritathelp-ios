//
//  MembersInAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 24/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class MembersInAssociation: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var searchMemberBar: UISearchBar!
    @IBOutlet weak var members_list: UITableView!
    var user : JSON = []
    var AssocID = ""
    var request = RequestModel()
    var param = [String: String]()
    var members : JSON = []
    var filtered:[String] = []
    var filteredTableData = [String]()
    var searchActive = false
    
    //init le tableview avec des data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellMemberAsso = members_list.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as! CustomCellMemberAsso
        var name = ""
        if(searchActive == false){
            name = String(members["response"][indexPath.row]["firstname"]) + " " + String(members["response"][indexPath.row]["lastname"])
        }
        else{
            name = String(filteredTableData[indexPath.row])
        }
        cell.setCell(name, imageName: define.path_picture + String(members["response"][indexPath.row]["thumb_path"]))
        
    
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if(searchActive == false){
            count = members["response"].count
        } else{
            count = filteredTableData.count
        }
        return count
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
            filteredTableData = filtered.filter({(dataItem: String) -> Bool in
                if dataItem.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        members_list.reloadData()
    }

    // init les données au chargement de la vue
    override func viewDidLoad() {
        super.viewDidLoad()
        members_list.tableFooterView = UIView()
        //let sfondo = UIImage(named: "BoisFond")
        //members_list.backgroundColor = UIColor(patternImage: sfondo!)
        
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "associations/" + AssocID + "/members"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.members = User
                self.members_list.reloadData()
                var i = 0
                while i < self.members.count{
                    self.filtered.append(String(self.members["response"][i]["firstname"]) + " " + String(self.members["response"][i]["lastname"]))
                    i += 1
                }

            }
            else {
                
            }
        });
        
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    //bouton quand on slide une ligne du tableview
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        //bouton Ajouter en ami
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
        //bouton kick un membre
        let shareAction2 = UITableViewRowAction(style: .Normal, title: "kick membre") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
        }
        
        shareAction.backgroundColor = UIColor(red: 50.0/255, green: 150.0/255, blue: 65.0/255, alpha: 1.0)
        shareAction2.backgroundColor = UIColor.redColor()
        
        return [shareAction]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //        // get a reference to the second view controller
        if(segue.identifier == "ProfilMember"){
            let indexPath = members_list.indexPathForCell(sender as! UITableViewCell)

            let secondViewController = segue.destinationViewController as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = String(members["response"][indexPath!.row]["id"])
        }

    }

    
}
