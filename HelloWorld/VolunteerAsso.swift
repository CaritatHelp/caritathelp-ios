//
//  VolunteerAsso.swift
//  Caritathelp
//
//  Created by Jeremy gros on 09/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class VolunteerAsso: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : JSON = []
    var assoVolunteer : JSON = []
    var idvolunteer = ""
    var param = [String: String]()
    var request = RequestModel()

    @IBOutlet weak var asso_list: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellAssoVolunteer = asso_list.dequeueReusableCellWithIdentifier("assovolunteer", forIndexPath: indexPath) as! CustomCellAssoVolunteer
        cell.setCell(String(assoVolunteer["response"][indexPath.row]["name"]), imageName: "", state: "Paris")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assoVolunteer["response"].count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "volunteers/" + idvolunteer + "/associations"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.assoVolunteer = User
                self.asso_list.reloadData()
            }
            else {
                
            }
        });
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "assovolunteerprofil"){
            let indexPath = asso_list.indexPathForCell(sender as! UITableViewCell)
            let currentCell = asso_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destinationViewController as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            //secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(assoVolunteer["response"][indexPath!.row]["id"])
            secondViewController.alreadyMember = String(assoVolunteer["response"][indexPath!.row]["rights"])
            //secondViewController.user = user
            
            navigationItem.title = "back"
        }
    }

}
