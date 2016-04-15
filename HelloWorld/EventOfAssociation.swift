//
//  EventOfAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 15/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class EventOfAssociation : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user : JSON = []
    var AssocID = ""
    var request = RequestModel()
    var param = [String: String]()
    var events : JSON = []
    
    
    @IBOutlet weak var events_list: UITableView!
    
    //let AssocList = ["la croix rouge", "les restos du coeur", "futsal"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = events_list.dequeueReusableCellWithIdentifier("EventsAssoCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = String(events["response"][indexPath.row]["title"])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, events_list.bounds.size.width, events_list.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.Center
        
        if(events["response"].count == 0){
            noDataLabel.text = "Cette assocation n'a aucun evenements à venir..."
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
        let val = "associations/" + AssocID + "/events"
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
        if(segue.identifier == "EventProfilVC"){
            let indexPath = events_list.indexPathForCell(sender as! UITableViewCell)
//            let currentCell = events_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destinationViewController as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(events["response"][indexPath!.row]["id"])
            //secondViewController.user = user
            print(indexPath?.row);
            navigationItem.title = "back"
        }
    }

}
