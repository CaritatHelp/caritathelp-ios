//
//  ProfilVolunteer.swift
//  Caritathelp
//
//  Created by Jeremy gros on 08/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView


class ProfilVolunteer: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate {
    
    var user : JSON = []
    var volunteer : JSON = []
    var idvolunteer = ""
    var param = [String: String]()
    var request = RequestModel()
    @IBOutlet weak var profil_list: UITableView!
    var main_picture = ""
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cellB : UITableViewCell!
        
        if indexPath.row == 0 {
        let cell : CustomCellProfilVolunteer = profil_list.dequeueReusableCellWithIdentifier("CellProfilVolunteer", forIndexPath: indexPath) as! CustomCellProfilVolunteer
            cell.setCell(String(volunteer["response"]["firstname"]) + " " + String(volunteer["response"]["lastname"]), DetailLabel: "", imageName: main_picture)
            
            let gradientBackgroundColors = [UIColor(red: 125.0/255, green: 191.0/255, blue: 149.0/255, alpha: 1.0).CGColor, UIColor.whiteColor().CGColor]
            let gradientLocations = [0.0,1.0]
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = gradientBackgroundColors
            gradientLayer.locations = gradientLocations
            
            gradientLayer.frame = cell.bounds
            let backgroundView = UIView(frame: cell.bounds)
            backgroundView.layer.insertSublayer(gradientLayer, atIndex: 0)
            cell.backgroundView = backgroundView
            
            return cell
        }
        else {
            let cell1 = profil_list.dequeueReusableCellWithIdentifier("MenuProfil", forIndexPath: indexPath)
            return cell1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 45
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profil_list.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        
        param["token"] = String(user["token"])
        let val = "volunteers/" + idvolunteer
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.volunteer = User
                self.main_picture = define.path_picture + String(User["response"]["thumb_path"])
                self.profil_list.reloadData()
                }
            else {
                
            }
        });

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "friendoffriend"){
            
            let secondViewController = segue.destinationViewController as! MyFriendsController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idfriend = idvolunteer
            secondViewController.fromProfil = true
        }
        if(segue.identifier == "AssoVolunteer"){
            
            let secondViewController = segue.destinationViewController as! VolunteerAsso
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = idvolunteer
        }
        if(segue.identifier == "fromprofilvolunteer"){
            
            let secondViewController = segue.destinationViewController as! LoadPhotoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.from = "1"
        }
        
        
    }

    
    

}
