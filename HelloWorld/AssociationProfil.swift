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
        refreshControl.addTarget(self, action: #selector(AssociationProfil.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    
    
    @IBOutlet weak var ButtonJoin: UIButton!
    @IBOutlet weak var ButtonMenuOwner: UIBarButtonItem!
    @IBOutlet weak var ActuAssoList: UITableView!
    //@IBOutlet weak var ImageProfilAsso: UIImageView!
    
    @IBOutlet weak var ImageProfilAsso: UIImageView!
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    
    let members = ["la croix rouge", "les restos du coeur", "futsal", ""]
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            print("Back Pressed")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : UITableViewCell!
        if indexPath.section == 0 {
            let cell1 : CustomCellHeaderAsso = ActuAssoList.dequeueReusableCell(withIdentifier: "ActuAssoCellHeader", for: indexPath) as! CustomCellHeaderAsso
            cell1.setCell(User: user, assoId: AssocID, rights: alreadyMember,imagePath: main_picture)
            return cell1
        }else{
            if indexPath.row == 0 {
                let cell1 = ActuAssoList.dequeueReusableCell(withIdentifier: "customcellactu", for: indexPath) as! CustomCellActu
                
                cell1.tapped_modify = { [unowned self] (selectedCell, Newcontent) -> Void in
                    let path = tableView.indexPathForRow(at: selectedCell.center)!
                    self.param["access-token"] = sharedInstance.header["access-token"]
                    self.param["client"] = sharedInstance.header["client"]
                    self.param["uid"] = sharedInstance.header["uid"]

                    self.param["content"] = Newcontent
                    self.request.request(type: "PUT", param: self.param, add: "news/" + String(describing: self.Actu[path.section - 1]["id"]), callback: {
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
                    let path = tableView.indexPathForRow(at: selectedCell.center)!
                    
                    self.param["access-token"] = sharedInstance.header["access-token"]
                    self.param["client"] = sharedInstance.header["client"]
                    self.param["uid"] = sharedInstance.header["uid"]

                    self.request.request(type: "DELETE", param: self.param, add: "news/" + String(describing: self.Actu[path.section - 1]["id"]) , callback: {
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
                    title = String(describing: Actu[indexPath.section - 1]["volunteer_name"]) + " a publié sur le mur de " + String(describing: Actu[indexPath.section - 1]["group_name"])
                var from = ""
                if Actu[indexPath.section - 1]["volunteer_id"] == user["id"] {
                    from = "true"
                }
                else {
                    from = "false"
                }
                cell1.setCell(NameLabel: title, DateLabel: String(describing: Actu[indexPath.section-1]["updated_at"]), imageName: define.path_picture + String(describing: Actu[indexPath.section-1]["thumb_path "]), content: String(describing: Actu[indexPath.section-1]["content"]), from: from)
            return cell1
            }
            else {
                let cell1 = ActuAssoList.dequeueReusableCell(withIdentifier: "gotocommentfromasso", for: indexPath) as UITableViewCell
                return cell1
            }
        }
        //return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Actu.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 }
        else {
            return 2 }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = TitleAssoc
        
        user = sharedInstance.volunteer
        self.ActuAssoList.addSubview(self.refreshControl)
        ActuAssoList.register(UINib(nibName: "CustomCellActu", bundle: nil), forCellReuseIdentifier: "customcellactu")
        ActuAssoList.estimatedRowHeight = 159.0
        ActuAssoList.rowHeight = UITableViewAutomaticDimension
        print("ASSO RIGHTS = \(alreadyMember)")
        if (alreadyMember != "owner"){
            self.ButtonMenuOwner.isEnabled = false
            self.ButtonMenuOwner.tintColor = UIColor.clear
        }else{
            self.ButtonMenuOwner.isEnabled = true
            
        }

        
        
        if(creation == false){
            print("enter donc false")
            refresh()
        }
        
    }

    func refresh(){
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "associations/" + AssocID
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Asso = User["response"]
                self.title = String(describing: self.Asso["name"])
                self.main_picture = define.path_picture + String(describing: User["thumb_path"])
                self.alreadyMember = String(describing: User["rights"])
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
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "associations/" + self.AssocID + "/news"
        self.request.request(type: "GET", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Actu = User["response"]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            
    
            // get a reference to the second view controller
            if(segue.identifier == "goToMembers"){
    
                let secondViewController = segue.destination as! MembersInAssociation
    
                // set a variable in the second view controller with the String to pass
                secondViewController.AssocID = AssocID
                //secondViewController.user = user
            }
            if(segue.identifier == "goToEvents"){
                
                let secondViewController = segue.destination as! EventOfAssociation
                
                // set a variable in the second view controller with the String to pass
                secondViewController.AssocID = AssocID
                //secondViewController.user = user
            }
            if(segue.identifier == "goToDescription"){
                
                let secondViewController = segue.destination as! DescriptionAssociation
                
                // set a variable in the second view controller with the String to pass
                secondViewController.Asso = Asso
                //secondViewController.user = user
            }
            if(segue.identifier == "goToMenuOwner"){
                
                let secondViewController = segue.destination as! MenuOwnerAssocation
                
                // set a variable in the second view controller with the String to pass
                secondViewController.Asso = Asso
                //secondViewController.user = user
            }
            if(segue.identifier == "gotopostfromasso"){
                
                let secondViewController = segue.destination as! PostStatutAssoController
                
                // set a variable in the second view controller with the String to pass
                secondViewController.AssoID = AssocID
                secondViewController.from = "asso"
            }
            if(segue.identifier == "gotocommentfromasso"){
                let indexPath = ActuAssoList.indexPath(for: sender as! UITableViewCell)
                let secondViewController = segue.destination as! CommentActuController
                
                // set a variable in the second view controller with the String to pass
                secondViewController.IDnews = String(describing: Actu[indexPath!.section-1]["id"])
                //secondViewController.from = "asso"
            }//
        }
    
    @IBAction func unwindToProfilAsso(_ sender: UIStoryboardSegue) {
        _ = sender.source
        
        
    }

    @IBAction func unwindToProfilAssoAfterPublish(_ sender: UIStoryboardSegue) {
        let data = sender.source as! PostStatutAssoController
        data.assoc_array["assoc_id"] = AssocID
        request.request(type: "POST", param: data.assoc_array,add: "news/wall_message", callback: {
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
