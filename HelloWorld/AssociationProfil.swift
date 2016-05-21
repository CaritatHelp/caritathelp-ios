//
//  AssociationProfil.swift
//  Caritathelp
//
//  Created by Jeremy gros on 16/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class AssociationProfil : UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var user : JSON = []
    var request = RequestModel()
    var TitleAssoc = ""
    var AssocID : String = ""
    var param = [String: String]()
    var Asso : JSON = []
    var alreadyMember = ""
    var creation = false;
    let gradientLayer = CAGradientLayer()
    
    
    @IBOutlet weak var ButtonJoin: UIButton!
    @IBOutlet weak var ButtonMenuOwner: UIBarButtonItem!
    @IBOutlet weak var ActuAssoList: UITableView!
    //@IBOutlet weak var ImageProfilAsso: UIImageView!
    
    @IBOutlet weak var ImageProfilAsso: UIImageView!
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    
    let members = ["la croix rouge", "les restos du coeur", "futsal", ""]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell : UITableViewCell!
        if indexPath.row == 0 {
            let cell1 : CustomCellHeaderAsso = ActuAssoList.dequeueReusableCellWithIdentifier("ActuAssoCellHeader", forIndexPath: indexPath) as! CustomCellHeaderAsso
            cell1.setCell(user, assoId: AssocID, rights: alreadyMember)
            return cell1
        }else{
        let cell1 = ActuAssoList.dequeueReusableCellWithIdentifier("ActuAssoCell", forIndexPath: indexPath)
            return cell1
        }
        //return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else {
            return 190
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = TitleAssoc
        
        user = sharedInstance.volunteer["response"]

        
        print("ASSO RIGHTS = \(alreadyMember)")
        if (alreadyMember != "owner"){
            self.ButtonMenuOwner.enabled = false
            self.ButtonMenuOwner.tintColor = UIColor.clearColor()
        }else{
            self.ButtonMenuOwner.enabled = true
            
        }

        
        if(creation == false){
            print("enter donc false")
        param["token"] = String(user["token"])
        let val = "associations/" + AssocID
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Asso = User
                self.title = String(self.Asso["response"]["name"])
                
                                //self.tableViewAssoc.reloadData()
            }
            else {
                
            }
        });
        }
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= -CGRectGetHeight((self.navigationController?.accessibilityFrame)!) {
//            adjustBackground(false)
//        } else {
//            adjustBackground(true)
//        }
        print("scroll vers le haut !")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
            // get a reference to the second view controller
            if(segue.identifier == "goToMembers"){
    
                let secondViewController = segue.destinationViewController as! MembersInAssociation
    
                // set a variable in the second view controller with the String to pass
                secondViewController.AssocID = AssocID
                //secondViewController.user = user
            }
            if(segue.identifier == "goToEvents"){
                
                let secondViewController = segue.destinationViewController as! EventOfAssociation
                
                // set a variable in the second view controller with the String to pass
                secondViewController.AssocID = AssocID
                //secondViewController.user = user
            }
            if(segue.identifier == "goToDescription"){
                
                let secondViewController = segue.destinationViewController as! DescriptionAssociation
                
                // set a variable in the second view controller with the String to pass
                secondViewController.Asso = Asso
                //secondViewController.user = user
            }
            if(segue.identifier == "goToMenuOwner"){
                
                let secondViewController = segue.destinationViewController as! MenuOwnerAssocation
                
                // set a variable in the second view controller with the String to pass
                secondViewController.Asso = Asso
                //secondViewController.user = user
            }
        }
    
    @IBAction func unwindToProfilAsso(sender: UIStoryboardSegue) {
        _ = sender.sourceViewController
        
        
    }

    
}
