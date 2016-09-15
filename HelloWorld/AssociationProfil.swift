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
    var Actu :JSON = []
    var alreadyMember = ""
    var creation = false;
    let gradientLayer = CAGradientLayer()
    var main_picture = ""
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AssociationProfil.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()

    
    
    @IBOutlet weak var ButtonJoin: UIButton!
    @IBOutlet weak var ButtonMenuOwner: UIBarButtonItem!
    @IBOutlet weak var ActuAssoList: UITableView!
    //@IBOutlet weak var ImageProfilAsso: UIImageView!
    
    @IBOutlet weak var ImageProfilAsso: UIImageView!
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    
    let members = ["la croix rouge", "les restos du coeur", "futsal", ""]
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            print("Back Pressed")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell : UITableViewCell!
        if indexPath.section == 0 {
            let cell1 : CustomCellHeaderAsso = ActuAssoList.dequeueReusableCellWithIdentifier("ActuAssoCellHeader", forIndexPath: indexPath) as! CustomCellHeaderAsso
            cell1.setCell(user, assoId: AssocID, rights: alreadyMember,imagePath: main_picture)
            return cell1
        }else{
            if indexPath.row == 0 {
                let cell1 = ActuAssoList.dequeueReusableCellWithIdentifier("customcellactu", forIndexPath: indexPath) as! CustomCellActu
                
                cell1.tapped_modify = { [unowned self] (selectedCell, Newcontent) -> Void in
                    let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                    self.param["token"] = String(self.user["token"])
                    self.param["content"] = Newcontent
                    self.request.request("PUT", param: self.param, add: "news/" + String(self.Actu["response"][path.section - 1]["id"]), callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            self.refreshActu()
                        }
                        else {
                            SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                        }
                    });
                    
                }
                
                cell1.tapped_delete = { [unowned self] (selectedCell, Newcontent) -> Void in
                    let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                    
                    self.param["token"] = String(self.user["token"])
                    self.request.request("DELETE", param: self.param, add: "news/" + String(self.Actu["response"][path.section - 1]["id"]) , callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            //self.refreshActu()
                            self.refreshActu()
                            
                        }
                        else {
                            SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                        }
                    });
                    
                }
                
                var title = ""
                    title = String(Actu["response"][indexPath.section - 1]["volunteer_name"]) + " a publié sur le mur de " + String(Actu["response"][indexPath.section - 1]["group_name"])
                var from = ""
                if Actu["response"][indexPath.section - 1]["volunteer_id"] == user["id"] {
                    from = "true"
                }
                else {
                    from = "false"
                }
                cell1.setCell(title, DateLabel: String(Actu["response"][indexPath.section-1]["updated_at"]), imageName: define.path_picture + String(Actu["response"][indexPath.section-1]["thumb_path "]), content: String(Actu["response"][indexPath.section-1]["content"]), from: from)
            return cell1
            }
            else {
                let cell1 = ActuAssoList.dequeueReusableCellWithIdentifier("gotocommentfromasso", forIndexPath: indexPath) as UITableViewCell
                return cell1
            }
        }
        //return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Actu["response"].count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = TitleAssoc
        
        user = sharedInstance.volunteer["response"]
        self.ActuAssoList.addSubview(self.refreshControl)
        ActuAssoList.registerNib(UINib(nibName: "CustomCellActu", bundle: nil), forCellReuseIdentifier: "customcellactu")
        ActuAssoList.estimatedRowHeight = 159.0
        ActuAssoList.rowHeight = UITableViewAutomaticDimension
        print("ASSO RIGHTS = \(alreadyMember)")
        if (alreadyMember != "owner"){
            self.ButtonMenuOwner.enabled = false
            self.ButtonMenuOwner.tintColor = UIColor.clearColor()
        }else{
            self.ButtonMenuOwner.enabled = true
            
        }

        
        
        if(creation == false){
            print("enter donc false")
            refresh()
        }
        
    }

    func refresh(){
        param["token"] = String(user["token"])
        let val = "associations/" + AssocID
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Asso = User
                self.title = String(self.Asso["response"]["name"])
                self.main_picture = define.path_picture + String(User["response"]["thumb_path"])
                self.alreadyMember = String(User["response"]["rights"])
                //self.ActuAssoList.reloadData()
                self.refreshControl.endRefreshing()
                self.refreshActu()
                
                
            }
            else {
                print("une erreur est survenue...")
            }
        });

    }
    
    func refreshActu() {
        self.param["token"] = String(self.user["token"])
        let val = "associations/" + self.AssocID + "/news"
        self.request.request("GET", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Actu = User
                self.ActuAssoList.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                print("une erreur est survenue...")
            }
        });

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
            if(segue.identifier == "gotopostfromasso"){
                
                let secondViewController = segue.destinationViewController as! PostStatutAssoController
                
                // set a variable in the second view controller with the String to pass
                secondViewController.AssoID = AssocID
                secondViewController.from = "asso"
            }
            if(segue.identifier == "gotocommentfromasso"){
                let indexPath = ActuAssoList.indexPathForCell(sender as! UITableViewCell)
                let secondViewController = segue.destinationViewController as! CommentActuController
                
                // set a variable in the second view controller with the String to pass
                secondViewController.IDnews = String(Actu["response"][indexPath!.section-1]["id"])
                //secondViewController.from = "asso"
            }//
        }
    
    @IBAction func unwindToProfilAsso(sender: UIStoryboardSegue) {
        _ = sender.sourceViewController
        
        
    }

    @IBAction func unwindToProfilAssoAfterPublish(sender: UIStoryboardSegue) {
        let data = sender.sourceViewController as! PostStatutAssoController
        data.assoc_array["assoc_id"] = AssocID
        request.request("POST", param: data.assoc_array,add: "news/wall_message", callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.refreshActu()
            }
            else {
                print("erreur de requete ... ")
            }
        });

        
        
    }
    
}
