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

class AllAssociations : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var asso_list : JSON = []
    var tmp_list : JSON = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AllAssociations.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    //let AssocList = ["la croix rouge", "les restos du coeur", "futsal"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(String(asso_list["response"][indexPath.row]["result_type"]))
        if String(asso_list["response"][indexPath.row]["result_type"]) == "volunteer" {
            let cell = tableViewAssoc.dequeueReusableCellWithIdentifier("researchVolunteer", forIndexPath: indexPath) as! CustomCellResearchAsso
            cell.setCell(String(asso_list["response"][indexPath.row]["name"]), imageName: define.path_picture + String(asso_list["response"][indexPath.row]["thumb_path"]), state: "volontaire")
            return cell
            
        }else if String(asso_list["response"][indexPath.row]["result_type"]) == "event" {
            let cell = tableViewAssoc.dequeueReusableCellWithIdentifier("researchEvent", forIndexPath: indexPath) as! CustomCellResearchAsso
            cell.setCell(String(asso_list["response"][indexPath.row]["name"]), imageName: define.path_picture + String(asso_list["response"][indexPath.row]["thumb_path"]), state: "évènement")
            return cell
        } else {
            let cell = tableViewAssoc.dequeueReusableCellWithIdentifier("researchAsso", forIndexPath: indexPath) as! CustomCellResearchAsso
            cell.setCell(String(asso_list["response"][indexPath.row]["name"]), imageName: define.path_picture + String(asso_list["response"][indexPath.row]["thumb_path"]), state: "association")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asso_list["response"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 69
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tbc = self.tabBarController  as! TabBarController
        user = tbc.user
        self.tableViewAssoc.addSubview(self.refreshControl)
        tableViewAssoc.tableFooterView = UIView()
        refresh("pierre")
    }
    
    func refresh(search: String){
        param["token"] = String(user["response"]["token"])
        param["research"] = search
        request.request("GET", param: param,add: "search", callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.asso_list = User
                self.refreshControl.endRefreshing()
                self.tableViewAssoc.reloadData()
            }
            else {
                print("erreure")
            }
        });
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath =  self.tableViewAssoc.indexPathForCell(sender as! UITableViewCell)
        
        // get a reference to the second view controller
        if(segue.identifier == "AssocVC3"){
            
            let currentCell = tableViewAssoc.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destinationViewController as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            secondViewController.TitleAssoc = currentCell.textLabel!.text!
            secondViewController.AssocID = String(asso_list["response"][indexPath!.row]["id"])
            secondViewController.alreadyMember = String(asso_list["response"][indexPath!.row]["rights"])
            //secondViewController.user = user
            navigationItem.title = "back"
        }
        if(segue.identifier == "showeventfromresearch"){
            let secondViewController = segue.destinationViewController as! ProfilEventController
            secondViewController.EventID = String(asso_list["response"][indexPath!.row]["id"])
        }
        if(segue.identifier == "showprofilfromresearch"){
            let secondViewController = segue.destinationViewController as! ProfilVolunteer
            print(indexPath?.row)
            secondViewController.idvolunteer = String(asso_list["response"][indexPath!.row]["id"])
        }
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        //self.refreshControl.beginRefreshing()
        //refresh()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //self.refreshControl.beginRefreshing()
        refresh(searchText)

    }

//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        tmp_list = asso_list
//        asso_list = []
//        var i = 0
//        var j = 0
//        while i <= tmp_list["response"].count {
//            if (String(tmp_list["response"][i]["name"]).lowercaseString as NSString).rangeOfString(searchText).length != 0 {
//                asso_list[j] = tmp_list["response"][i]
//                j += 1
//            }
//            i += 1
//        }
//        tableViewAssoc.reloadData()
//    }
    
}



class CustomCellResearchAsso: UITableViewCell {
    
    
    @IBOutlet weak var PictureAsso: UIImageView!
    
    @IBOutlet weak var NameAsso: UILabel!
    @IBOutlet weak var Type: UILabel!
    
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
    
    func setCell(NameLabel: String, imageName: String, state: String){
        self.NameAsso.text! = NameLabel
        self.PictureAsso.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
        self.PictureAsso.layer.cornerRadius = 10
        self.PictureAsso.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.PictureAsso.layer.masksToBounds = true
        self.PictureAsso.clipsToBounds = true
        self.Type.text = state
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}
