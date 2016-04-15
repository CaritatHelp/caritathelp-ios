//
//  AllAssociations.swift
//  Caritathelp
//
//  Created by Jeremy gros on 20/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AllAssociations : UIViewController, UITableViewDataSource, UITableViewDelegate{
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var asso_list : JSON = []
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    let AssocList = ["la croix rouge", "les restos du coeur", "futsal"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableViewAssoc.dequeueReusableCellWithIdentifier("myassoc", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asso_list["response"].count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tbc = self.tabBarController  as! TabBarController
        user = tbc.user

        
        param["token"] = String(user["response"]["token"])
        request.request("GET", param: param,add: "associations", callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.asso_list = User
                self.tableViewAssoc.reloadData()
            }
            else {
                
            }
        });

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "AssocVC3"){
            let indexPath = tableViewAssoc.indexPathForCell(sender as! UITableViewCell)
            let currentCell = tableViewAssoc.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destinationViewController as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(asso_list["response"][indexPath!.row]["id"])
            secondViewController.alreadyMember = String(asso_list["response"][indexPath!.row]["rights"])
            //secondViewController.user = user

            navigationItem.title = "back"
        }
    }

    
}