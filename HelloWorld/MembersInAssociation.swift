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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCellMemberAsso = members_list.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! CustomCellMemberAsso
        var name = ""
        if(searchActive == false){
            name = String(describing: members["response"][indexPath.row]["firstname"]) + " " + String(describing: members["response"][indexPath.row]["lastname"])
        }
        else{
            name = String(filteredTableData[indexPath.row])
        }
        cell.setCell(NameLabel: name, imageName: define.path_picture + String(describing: members["response"][indexPath.row]["thumb_path"]))
        
    
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if(searchActive == false){
            count = members["response"].count
        } else{
            count = filteredTableData.count
        }
        return count
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
            filteredTableData = filtered.filter({(dataItem: String) -> Bool in
                if dataItem.range(of: searchText, options: .caseInsensitive) != nil {
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
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "associations/" + AssocID + "/members"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.members = User
                self.members_list.reloadData()
                var i = 0
                while i < self.members.count{
                    self.filtered.append(String(describing: self.members["response"][i]["firstname"]) + " " + String(describing: self.members["response"][i]["lastname"]))
                    i += 1
                }

            }
            else {
                
            }
        });
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    //bouton quand on slide une ligne du tableview
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //bouton Ajouter en ami
        let shareAction = UITableViewRowAction(style: .normal, title: "Ajouter en ami") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]

            self.param["volunteer_id"] = String(describing: self.members["response"][indexPath.row]["id"])
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
        //bouton kick un membre
        let shareAction2 = UITableViewRowAction(style: .normal, title: "kick membre") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
        }
        
        shareAction.backgroundColor = UIColor(red: 50.0/255, green: 150.0/255, blue: 65.0/255, alpha: 1.0)
        shareAction2.backgroundColor = UIColor.red
        
        return [shareAction]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        // get a reference to the second view controller
        if(segue.identifier == "ProfilMember"){
            let indexPath = members_list.indexPath(for: sender as! UITableViewCell)

            let secondViewController = segue.destination as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = String(describing: members["response"][indexPath!.row]["id"])
        }

    }

    
}
