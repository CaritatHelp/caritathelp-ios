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
import SCLAlertView

class MyAssociations : UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var user : JSON = []
    var titleAssoc = ""
    var request = RequestModel()
    var param = [String: String]()
    var asso_list : JSON = []
    var asso_member_list : JSON = []
    var asso_created_list : JSON = []
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MyAssociations.loadDataFirstView), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var createdAssoCollection: UICollectionView!
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    @IBOutlet weak var myStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageAssoCreated: UIImageView!
    @IBOutlet weak var nomAssoCreated: UILabel!
    @IBOutlet weak var viewAssoCreated: UIView!
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCellMyAsso = tableViewAssoc.dequeueReusableCell(withIdentifier: "myassoc", for: indexPath) as! CustomCellMyAsso

        let state = String(describing: asso_member_list[indexPath.row]["nb_members"]) + " membres"
            cell.setCell(NameLabel: String(describing: asso_member_list[indexPath.row]["name"]), imageName: define.path_picture + String(describing: asso_member_list[indexPath.row]["thumb_path"]), state: state)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: tableViewAssoc.bounds.size.width, height: tableViewAssoc.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        
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
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "volunteers/" + String(describing: user["id"]) + "/associations"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                var TableData:Array< JSON > = Array < JSON >()
                var TableData2:Array< JSON > = Array < JSON >()
                self.asso_list = User["response"]
                let total = self.asso_list.count
                var i = 0
                while i < total{
                    if(self.asso_list[i]["rights"] == "owner"){
                            //self.asso_created_list.rawValue
                        TableData.append(self.asso_list[i])
                    }else{
                        TableData2.append(self.asso_list[i])
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
                self.refreshControl.endRefreshing()

            }
            else {
                
            }
        });

    }
    
    //COLLECTION VIEW
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asso_created_list.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomCellCollectionCreateAsso = createdAssoCollection.dequeueReusableCell(withReuseIdentifier: "CreateAssoCell", for: indexPath) as! CustomCellCollectionCreateAsso
        print("CHEMIN :: " + define.path_picture + String(describing: asso_created_list[indexPath.row]["thumb_path"]))
            cell.setData(image: define.path_picture + String(describing: asso_created_list[indexPath.row]["thumb_path"]), name: String(describing: asso_created_list[indexPath.row]["name"]))
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mes associations"
        tableViewAssoc.tableFooterView = UIView()
        self.tableViewAssoc.addSubview(self.refreshControl)
        loadDataFirstView()

        
    }
    
    func refresh() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        
        //var unsubscribe = UITableViewRowAction(style: .Normal, title: "Quitter") { handler: (UITableViewRowAction, NSIndexPath) -> Void))
    
            let shareAction = UITableViewRowAction(style: .normal, title: "Quitter") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
                
                print("vous quittez cette association")
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                self.param["assoc_id"] = String(describing: self.asso_member_list[indexPath!.row]["id"])
                let val = "membership/leave"
                self.request.request(type: "DELETE", param: self.param,add: val, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        //self.asso_list = User
                        if User["status"] == 200 {
                            SCLAlertView().showSuccess("Opération réussi", subTitle: String(describing: User["message"]))
                             self.tableViewAssoc.reloadData()
                        }
                        else {
                            SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                        }
                    }
                    else {
                        
                    }
                });

                
                
            }
            
            shareAction.backgroundColor = UIColor.red
            
            return [shareAction]

        }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        // get a reference to the second view controller
        if(segue.identifier == "AssocProfilVC2"){
             let indexPath = tableViewAssoc.indexPath(for: sender as! UITableViewCell)
//            let currentCell : CustomCellMyAsso = tableViewAssoc.cellForRowAtIndexPath(indexPath!) as! CustomCellMyAsso!
            
            
            
            let secondViewController = segue.destination as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
//            secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(describing: asso_member_list[indexPath!.row]["id"])
            secondViewController.alreadyMember = String(describing: asso_member_list[indexPath!.row]["rights"])
            print(indexPath?.row);
            navigationItem.title = "back"
        }
        if(segue.identifier == "AssocProfilVC4"){
            let indexPath = createdAssoCollection.indexPath(for: sender as! UICollectionViewCell)
            //            let currentCell : CustomCellMyAsso = tableViewAssoc.cellForRowAtIndexPath(indexPath!) as! CustomCellMyAsso!
            
            
            
            let secondViewController = segue.destination as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            //            secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(describing: asso_created_list[indexPath!.row]["id"])
            secondViewController.alreadyMember = String(describing: asso_created_list[indexPath!.row]["rights"])
            print(indexPath?.row);
            navigationItem.title = "back"
        }
        
    }
    
    @IBAction func unwindToMyAsso(_ sender: UIStoryboardSegue) {
        print("ENTER ******")
         let data = sender.source as! NewAssociation
        request.request(type: "POST", param: data.assoc_array,add: "associations", callback: {
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
