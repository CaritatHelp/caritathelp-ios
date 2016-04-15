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

class AssociationProfil : UIViewController, UITableViewDataSource,UITableViewDelegate {
    var user : JSON = [] //all data about user
    var request = RequestModel() //permet d'appeler le model request
    var TitleAssoc = "" //titre asso
    var AssocID : String = "" // ID asso
    var param = [String: String]() // tableau pour les paramètre envoyer en requete
    var Asso : JSON = [] // all data sur l'asso
    var alreadyMember = "" // pour savoir si le user est deja membre
    var creation = false;
    let gradientLayer = CAGradientLayer()
    
    
    @IBOutlet weak var ButtonJoin: UIButton!
    @IBOutlet weak var ButtonMenuOwner: UIBarButtonItem!
    @IBOutlet weak var ActuAssoList: UITableView!
    
    @IBOutlet weak var ImageProfilAsso: UIImageView!
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    
    //initialise le tableview avec des data
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
    
    // return number of row of the tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    // permet d'ajuster la taille des cellules
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else {
            return 190
        }
         return 0
    }
    
    //load data on chargmement
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
