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
    var actu : JSON = []
    var idvolunteer = ""
    var param = [String: String]()
    var request = RequestModel()
    @IBOutlet weak var profil_list: UITableView!
    var main_picture = ""
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cellB : UITableViewCell!
        
        if indexPath.row == 0 {
        let cell : CustomCellProfilVolunteer = profil_list.dequeueReusableCellWithIdentifier("CellProfilVolunteer", forIndexPath: indexPath) as! CustomCellProfilVolunteer
            cell.setCell(String(volunteer["response"]["firstname"]) + " " + String(volunteer["response"]["lastname"]), DetailLabel: String(volunteer["response"]["friendship"]), imageName: main_picture, User: volunteer["response"])
            
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
        else if indexPath.row == 1 {
                let cell1 = profil_list.dequeueReusableCellWithIdentifier("MenuProfil", forIndexPath: indexPath)
            return cell1
        }
        else {
            let cell1 : CustomCellProfilActu = profil_list.dequeueReusableCellWithIdentifier("ActuProfil", forIndexPath: indexPath) as! CustomCellProfilActu
            cell1.setCell(String(actu["response"][indexPath.row - 1]["title"]), imageName: define.path_picture + String(actu["response"][indexPath.row - 1]["thumb_path"]), Date: String(actu["response"][indexPath.row - 1]["updated_at"]), Content: String(actu["response"][indexPath.row - 1]["content"]))
            return cell1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actu["response"].count + 2
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else if indexPath.row == 1 {
            return 45
        }else {
            return 150
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
                let val2 = "volunteers/" + self.idvolunteer + "/news"
                self.request.request("GET", param: self.param,add: val2, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.actu = User
                        self.profil_list.reloadData()
                    }
                    else {
                        
                    }
                });

                }
            else {
                
            }
        });

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = profil_list.indexPathForCell(sender as! UITableViewCell)
        
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
        if(segue.identifier == "fromprofiltoevents"){
            
            let secondViewController = segue.destinationViewController as! VolunteerEventsController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = idvolunteer
        }//fromprofiltoevents
        if(segue.identifier == "fromprofilvolunteer"){
            
            let secondViewController = segue.destinationViewController as! LoadPhotoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.from = "1"
        }
        if(segue.identifier == "gotopostfromprofil"){
            
            let secondViewController = segue.destinationViewController as! PostStatutAssoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.from = "profil"
        }
        if(segue.identifier == "showcommentfromprofil"){
            
            let secondViewController = segue.destinationViewController as! CommentActuController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.IDnews = String(actu["response"][indexPath!.row - 1]["id"])
        }
        
        
    }

    
    

}


class CustomCellProfilActu: UITableViewCell {
    
    @IBOutlet weak var PictureActu: UIImageView!
    
    @IBOutlet weak var NameActu: UILabel!
    @IBOutlet weak var DateActu: UILabel!
    
    @IBOutlet weak var contentActu: UITextView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(NameLabel: String, imageName: String, Date: String, Content: String){
        self.NameActu.text = NameLabel
        self.PictureActu.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
        self.PictureActu.layer.cornerRadius = 10
        self.PictureActu.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.PictureActu.layer.masksToBounds = true
        self.PictureActu.clipsToBounds = true
        self.DateActu.text = Date
        self.contentActu.text = Content
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}

