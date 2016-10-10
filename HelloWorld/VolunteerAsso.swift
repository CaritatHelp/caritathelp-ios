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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCellAssoVolunteer = asso_list.dequeueReusableCell(withIdentifier: "assovolunteer", for: indexPath) as! CustomCellAssoVolunteer
        cell.setCell(NameLabel: String(describing: assoVolunteer["response"][indexPath.row]["name"]), imageName: define.path_picture + String(describing: assoVolunteer["response"][indexPath.row]["thumb_path"]), state: "Paris")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assoVolunteer["response"].count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = sharedInstance.volunteer["response"]
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "volunteers/" + idvolunteer + "/associations"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.assoVolunteer = User
                self.asso_list.reloadData()
            }
            else {
                
            }
        });
        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "assovolunteerprofil"){
            let indexPath = asso_list.indexPath(for: sender as! UITableViewCell)
            _ = asso_list.cellForRow(at: indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destination as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            //secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(describing: assoVolunteer["response"][indexPath!.row]["id"])
            secondViewController.alreadyMember = String(describing: assoVolunteer["response"][indexPath!.row]["rights"])
            //secondViewController.user = user
            
            navigationItem.title = "back"
        }
    }

}
