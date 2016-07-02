//
//  VolunteerEvents.swift
//  Caritathelp
//
//  Created by Jeremy gros on 02/07/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class VolunteerEventsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var idvolunteer = ""
    var notifs : JSON = []
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(VolunteerNotificationController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var list_notif: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = list_notif.dequeueReusableCellWithIdentifier("CellEventVolunteer", forIndexPath: indexPath) as! CustomCellEventVolunteer
        
        var detail = ""
        if notifs["response"][indexPath.row]["nb_friends_members"] == "0" {
            detail = ""
        } else if notifs["response"][indexPath.row]["nb_friends_members"] == "1" {
            detail = String(notifs["response"][indexPath.row]["nb_friends_members"]) + " ami y participent"
        }else{
            detail = String(notifs["response"][indexPath.row]["nb_friends_members"]) + " amis y participent"
        }
        
        cell.setCell(String(notifs["response"][indexPath.row]["title"]), DetailLabel: detail, imageName: define.path_picture + String(notifs["response"][indexPath.row]["thumb_path"]))
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifs["response"].count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list_notif.tableFooterView = UIView()
        self.list_notif.addSubview(self.refreshControl)
        user = sharedInstance.volunteer["response"]
        refresh()
        
    }
    
    
    
    func refresh() {
        // Code to refresh table view
        param["token"] = String(user["token"])
        let val = "volunteers/" + idvolunteer + "/events"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.notifs = User
                self.list_notif.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                
            }
        });
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = list_notif.indexPathForCell(sender as! UITableViewCell)
        //        // get a reference to the second view controller
        if(segue.identifier == "fromprofileventstoevent"){
            let secondViewController = segue.destinationViewController as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(notifs["response"][indexPath!.row]["id"])
        }
    }

    
}