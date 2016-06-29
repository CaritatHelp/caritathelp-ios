//
//  MyAssociations.swift
//  Caritathelp
//
//  Created by Jeremy gros on 02/02/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyAssociations : UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var user : JSON = []
    var titleAssoc = ""
    var request = RequestModel()
    var param = [String: String]()
    var asso_list : JSON = []
    var asso_member_list : JSON = []
    var asso_created_list : JSON = []
    @IBOutlet weak var createdAssoCollection: UICollectionView!
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    @IBOutlet weak var myStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageAssoCreated: UIImageView!
    @IBOutlet weak var nomAssoCreated: UILabel!
    @IBOutlet weak var viewAssoCreated: UIView!
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellMyAsso = tableViewAssoc.dequeueReusableCellWithIdentifier("myassoc", forIndexPath: indexPath) as! CustomCellMyAsso

        let state = String(asso_member_list[indexPath.row]["nb_members"]) + " membres"
            cell.setCell(String(asso_member_list[indexPath.row]["name"]), imageName: define.path_picture + String(asso_member_list[indexPath.row]["thumb_path"]), state: state)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, tableViewAssoc.bounds.size.width, tableViewAssoc.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.Center
        
        if(asso_member_list.count == 0){
            noDataLabel.text = "Vous ne faites partis d'aucune association.."
        }
        else{
            noDataLabel.text = ""
        }
        tableViewAssoc.backgroundView = noDataLabel
        return asso_member_list.count
    }
    
    
    func loadDataFirstView(){
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "volunteers/" + String(user["id"]) + "/associations"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                var TableData:Array< JSON > = Array < JSON >()
                var TableData2:Array< JSON > = Array < JSON >()
                self.asso_list = User
                let total = self.asso_list["response"].count
                var i = 0
                while i < total{
                    if(self.asso_list["response"][i]["rights"] == "owner"){
                            //self.asso_created_list.rawValue
                        TableData.append(self.asso_list["response"][i])
                    }else{
                        TableData2.append(self.asso_list["response"][i])
                    }
                    i += 1
                }
                self.asso_member_list = JSON(TableData2)
                self.asso_created_list = JSON(TableData)
                print("************")
                print(self.asso_created_list)
                print("-------")
                print(self.asso_member_list)
                print("++++++++++++")
                self.tableViewAssoc.reloadData()
                self.createdAssoCollection.reloadData()
            }
            else {
                
            }
        });

    }
    
    //COLLECTION VIEW
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asso_created_list.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : CustomCellCollectionCreateAsso = createdAssoCollection.dequeueReusableCellWithReuseIdentifier("CreateAssoCell", forIndexPath: indexPath) as! CustomCellCollectionCreateAsso
        print("CHEMIN :: " + define.path_picture + String(asso_created_list[indexPath.row]["thumb_path"]))
            cell.setData(define.path_picture + String(asso_created_list[indexPath.row]["thumb_path"]), name: String(asso_created_list[indexPath.row]["name"]))
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mes associations"
        tableViewAssoc.tableFooterView = UIView()
        loadDataFirstView()

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: (UITableViewRowAction, NSIndexPath) -> Void))
    
            let shareAction = UITableViewRowAction(style: .Normal, title: "Quitter") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
                print("vous quittez cette association")
                self.param["token"] = String(self.user["response"]["token"])
                self.param["assoc_id"] = String(self.asso_list["response"][indexPath!.row]["id"])
                self.param["volunteer_id"] = String(self.user["response"]["id"])
                let val = "membership/kick"
                self.request.request("DELETE", param: self.param,add: val, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        //self.asso_list = User
                        self.tableViewAssoc.reloadData()
                    }
                    else {
                        
                    }
                });

                
                
            }
            
            shareAction.backgroundColor = UIColor.redColor()
            
            return [shareAction]

        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "AssocProfilVC2"){
             let indexPath = tableViewAssoc.indexPathForCell(sender as! UITableViewCell)
//            let currentCell : CustomCellMyAsso = tableViewAssoc.cellForRowAtIndexPath(indexPath!) as! CustomCellMyAsso!
            
            
            
            let secondViewController = segue.destinationViewController as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
//            secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(asso_member_list[indexPath!.row]["id"])
            secondViewController.alreadyMember = String(asso_member_list[indexPath!.row]["rights"])
            print(indexPath?.row);
            navigationItem.title = "back"
        }
        if(segue.identifier == "AssocProfilVC4"){
            let indexPath = createdAssoCollection.indexPathForCell(sender as! UICollectionViewCell)
            //            let currentCell : CustomCellMyAsso = tableViewAssoc.cellForRowAtIndexPath(indexPath!) as! CustomCellMyAsso!
            
            
            
            let secondViewController = segue.destinationViewController as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            //            secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(asso_created_list[indexPath!.row]["id"])
            secondViewController.alreadyMember = String(asso_created_list[indexPath!.row]["rights"])
            print(indexPath?.row);
            navigationItem.title = "back"
        }
        
    }
    
    @IBAction func unwindToMyAsso(sender: UIStoryboardSegue) {
         let data = sender.sourceViewController as! NewAssociation
        request.request("POST", param: data.assoc_array,add: "associations", callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.loadDataFirstView()
            }
            else {
                print("erreur de requete ... ")
            }
        });

       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "showProfil") {
//            
//            let indexPath = tableViewRanking.indexPathForCell(sender as! UITableViewCell)
//            
//            let nav = segue.destinationViewController as! UINavigationController
//            let svc = nav.topViewController as! ProfilViewController;
//            
//            svc.toPassUserName = (model.accessStarterRankChallenges?.rank![(indexPath?.item)! - 3].userName)!
//        }
//    }

}