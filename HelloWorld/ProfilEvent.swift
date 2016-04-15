//
//  ProfilEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 16/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfilEventController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var StateMembersOnEvent: UIButton!
    @IBOutlet weak var eventsNewsList: UITableView!
     var param = [String: String]()
    var request = RequestModel()
    var EventID : String = ""
    var Event : JSON = []
     var user : JSON = []
    
    @IBOutlet weak var JoinEventBtn: UIBarButtonItem!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventsNewsList.dequeueReusableCellWithIdentifier("EventNewsCell", forIndexPath: indexPath)
        
//        cell.textLabel!.text = String(events["response"][indexPath.row]["title"])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    @IBAction func JoinEvent(sender: AnyObject) {
        //quitter un event en tant que membre
        if(String(Event["response"]["rights"]) == "member"){
            param["token"] = String(user["token"])
            param["event_id"] = EventID
            let val = "guests/leave"
            request.request("DELETE", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.JoinEventBtn.image = UIImage(named: "event_not_joined")
                    //self.tableViewAssoc.reloadData()
                }
                else {
                    print("erreur ne peux pas se retirer...")
                }
            });

        }
            //empecher a l'host de quitter
        else if (String(Event["response"]["rights"]) == "host"){
            let refreshAlert = UIAlertController(title: "Attention", message: "Vous êtes le créateur de l'évènement !", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        else{//Rejoindre l'event (envoyer une demande à l'host)
            param["token"] = String(user["token"])
            param["event_id"] = EventID
            let val = "guests/join"
            request.request("POST", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.JoinEventBtn.image = UIImage(named: "event_joined")
                    //self.tableViewAssoc.reloadData()
                }
                else {
                    print("erreur ne peux pas participer...")
                }
            });
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(EventID)
        print("----------")
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "events/" + EventID
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Event = User
                self.navigationItem.title = String(self.Event["response"]["title"])
                if(String(self.Event["response"]["rights"]) == "host" || String(self.Event["response"]["rights"]) == "member"){
                    self.JoinEventBtn.image = UIImage(named: "event_joined")
                }
                //self.tableViewAssoc.reloadData()
            }
            else {
                
            }
        });
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventInfoVC"){
            let secondViewController = segue.destinationViewController as! InformationsEvent
            
            // set a variable in the second view controller with the String to pass
           
            secondViewController.Event = Event
        }
        if(segue.identifier == "EventMembersVC"){
            let secondViewController = segue.destinationViewController as! MembersEventController
            
            // set a variable in the second view controller with the String to pass
            
            secondViewController.EventID = String(Event["response"]["id"])
        }
    }

    
}