//
//  MyEvents.swift
//  Caritathelp
//
//  Created by Jeremy gros on 17/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyEventsController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var events : JSON = []

    
    @IBOutlet weak var events_list: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellMyEvents = events_list.dequeueReusableCellWithIdentifier("MyEventsCell", forIndexPath: indexPath) as! CustomCellMyEvents
        
//        cell.textLabel!.text = String(events["response"][indexPath.row]["title"])
        cell.setCell(String(events["response"][indexPath.row]["title"]), imageName: "", state: "Jeudi 24 Mars")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, events_list.bounds.size.width, events_list.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.Center

        if(events["response"].count == 0){
            noDataLabel.text = "Vous n'avez aucun evenement prochainement"
        }
        else{
            noDataLabel.text = ""
        }
        events_list.backgroundView = noDataLabel

        return events["response"].count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events_list.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "volunteers/" + String(user["id"]) + "/events"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.events = User
                self.events_list.reloadData()
            }
            else {
                
            }
        });
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventProfilVC2"){
            let indexPath = events_list.indexPathForCell(sender as! UITableViewCell)
            //            let currentCell = events_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destinationViewController as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            print(events["response"])
            print("*$$$$$$$*************")
            secondViewController.EventID = String(events["response"][indexPath!.row]["id"])
            //secondViewController.user = user
            print(indexPath?.row);
            //navigationItem.title = "back"
        }
    }

}