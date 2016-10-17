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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = events_list.dequeueReusableCell(withIdentifier: "EventsAssoCell", for: indexPath)
        
        cell.textLabel!.text = String(describing: events[indexPath.row]["title"])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x:0,y: 0,width: events_list.bounds.size.width,height: events_list.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        
        if(events.count == 0){
            noDataLabel.text = "Cette assocation n'a aucun evenements à venir..."
        }
        else{
            noDataLabel.text = ""
        }
        events_list.backgroundView = noDataLabel
        return events.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events_list.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "associations/" + AssocID + "/events"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.events = User["response"]
                self.events_list.reloadData()
            }
            else {
                
            }
        });
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventProfilVC"){
            let indexPath = events_list.indexPath(for: sender as! UITableViewCell)
//            let currentCell = events_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destination as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(describing: events[indexPath!.row]["id"])
            //secondViewController.user = user
            print(indexPath?.row);
            navigationItem.title = "back"
        }
    }

}
