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
        refreshControl.addTarget(self, action: #selector(AllAssociations.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var tableViewAssoc: UITableView!
    //let AssocList = ["la croix rouge", "les restos du coeur", "futsal"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(String(describing: asso_list["response"][indexPath.row]["result_type"]))
        if String(describing: asso_list["response"][indexPath.row]["result_type"]) == "volunteer" {
            let cell = tableViewAssoc.dequeueReusableCell(withIdentifier: "researchVolunteer", for: indexPath as IndexPath) as! CustomCellResearchAsso
            cell.setCell(NameLabel: String(describing: asso_list["response"][indexPath.row]["name"]), imageName: define.path_picture + String(describing: asso_list["response"][indexPath.row]["thumb_path"]), state: "volontaire")
            return cell
            
        }else if String(describing: asso_list["response"][indexPath.row]["result_type"]) == "event" {
            let cell = tableViewAssoc.dequeueReusableCell(withIdentifier: "researchEvent", for: indexPath as IndexPath) as! CustomCellResearchAsso
            cell.setCell(NameLabel: String(describing: asso_list["response"][indexPath.row]["name"]), imageName: define.path_picture + String(describing: asso_list["response"][indexPath.row]["thumb_path"]), state: "évènement")
            return cell
        } else {
            let cell = tableViewAssoc.dequeueReusableCell(withIdentifier: "researchAsso", for: indexPath as IndexPath) as! CustomCellResearchAsso
            cell.setCell(NameLabel: String(describing: asso_list["response"][indexPath.row]["name"]), imageName: define.path_picture + String(describing: asso_list["response"][indexPath.row]["thumb_path"]), state: "association")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asso_list["response"].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tbc = self.tabBarController  as! TabBarController
        user = tbc.user
        self.tableViewAssoc.addSubview(self.refreshControl)
        //tableViewAssoc.tableFooterView = UIView()
        refresh(search: "pierre")
    }
    
    func refresh(search: String){
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        self.param["research"] = search
        request.request(type: "GET", param: self.param, add: "search", callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.asso_list = User
                self.refreshControl.endRefreshing()
                self.tableViewAssoc.reloadData()
            }
            else {
                print("erreure")
            }
        })
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath =  self.tableViewAssoc.indexPath(for: sender as! UITableViewCell)
        
        // get a reference to the second view controller
        if(segue.identifier == "AssocVC3"){
            
            //let currentCell = tableViewAssoc.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destination as! AssociationProfil
            
            // set a variable in the second view controller with the String to pass
            secondViewController.TitleAssoc = String(describing: asso_list["response"][indexPath!.row]["name"])
            secondViewController.AssocID = String(describing: asso_list["response"][indexPath!.row]["id"])
            secondViewController.alreadyMember = String(describing: asso_list["response"][indexPath!.row]["rights"])
            //secondViewController.user = user
            navigationItem.title = "back"
        }
        if(segue.identifier == "showeventfromresearch"){
            let secondViewController = segue.destination as! ProfilEventController
            secondViewController.EventID = String(describing: asso_list["response"][indexPath!.row]["id"])
        }
        if(segue.identifier == "showprofilfromresearch"){
            let secondViewController = segue.destination as! ProfilVolunteer
            print(indexPath?.row)
            secondViewController.idvolunteer = String(describing: asso_list["response"][indexPath!.row]["id"])
        }
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        //self.refreshControl.beginRefreshing()
        //refresh()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self.refreshControl.beginRefreshing()
        refresh(search: searchText)

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
    @IBOutlet weak var `Type`: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(NameLabel: String, imageName: String, state: String){
        self.NameAsso.text! = NameLabel
        self.PictureAsso.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.PictureAsso.layer.cornerRadius = 10
        self.PictureAsso.layer.borderColor = UIColor.darkGray.cgColor;
        self.PictureAsso.layer.masksToBounds = true
        self.PictureAsso.clipsToBounds = true
        self.Type.text = state
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}
