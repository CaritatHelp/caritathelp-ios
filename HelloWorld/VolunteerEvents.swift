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
        refreshControl.addTarget(self, action: #selector(VolunteerNotificationController.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var list_notif: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = list_notif.dequeueReusableCell(withIdentifier: "CellEventVolunteer", for: indexPath) as! CustomCellEventVolunteer
        
        var detail = ""
        if notifs[indexPath.row]["nb_friends_members"] == "0" {
            detail = ""
        } else if notifs[indexPath.row]["nb_friends_members"] == "1" {
            detail = String(describing: notifs[indexPath.row]["nb_friends_members"]) + " ami y participent"
        }else{
            detail = String(describing: notifs[indexPath.row]["nb_friends_members"]) + " amis y participent"
        }
        
        cell.setCell(NameLabel: String(describing: notifs[indexPath.row]["title"]), DetailLabel: detail, imageName: define.path_picture + String(describing: notifs[indexPath.row]["thumb_path"]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifs.count
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
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "volunteers/" + idvolunteer + "/events"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.notifs = User["response"]
                self.list_notif.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                
            }
        });
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = list_notif.indexPath(for: sender as! UITableViewCell)
        //        // get a reference to the second view controller
        if(segue.identifier == "fromprofileventstoevent"){
            let secondViewController = segue.destination as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(describing: notifs[indexPath!.row]["id"])
        }
    }

    
}
