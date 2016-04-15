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
    var user : JSON = []
    var param = [String: String]()
    var request = RequestModel()
    
    
    @IBOutlet weak var list_friends: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomFriendsCell = list_friends.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! CustomFriendsCell
        let name = String(friends["response"][indexPath.row]["firstname"]) + " " + String(friends["response"][indexPath.row]["lastname"])
        cell.setCell(name, DetailLabel: "", imageName: "")
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
        return friends["response"].count
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        list_friends.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "volunteers/" + String(user["id"]) + "/friends"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User
                self.list_friends.reloadData()
            }
            else {
                
            }
        });

    }
}
