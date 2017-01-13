//
//  EventOfAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 15/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SnapKit
import SCLAlertView

class EventOfAssociation : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user : JSON = []
    var AssocID = ""
    var rights = ""
    var request = RequestModel()
    var param = [String: String]()
    var events : JSON = []
    
    
    @IBOutlet weak var events_list: UITableView!
    
    //let AssocList = ["la croix rouge", "les restos du coeur", "futsal"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = events_list.dequeueReusableCell(withIdentifier: "EventsAssoCell", for: indexPath) as! EventOfAssoTableViewCell
        cell.setCell(pathImage: define.path_picture + String(describing: self.events[indexPath.row]["thumb_path"]), name: String(describing: self.events[indexPath.row]["title"]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x:0,y: 0,width: events_list.bounds.size.width,height: events_list.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        
        if(events.count == 0){
            noDataLabel.text = "Cette assocation n'a aucun evenements à venir..."
        }
        else{
            noDataLabel.text = ""
        }
        events_list.backgroundView = noDataLabel
        return events.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events_list.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        self.refresh()
    }
    
    func refresh() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "associations/" + AssocID + "/events"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.events = User["response"]
                self.events_list.reloadData()
            }
            else {
                
            }
        });
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if rights == "owner" || rights == "admin" {
            let shareAction2 = UITableViewRowAction(style: .normal, title: "supprimer") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    showCircularIcon: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("oui") {
                    self.param["access-token"] = sharedInstance.header["access-token"]
                    self.param["client"] = sharedInstance.header["client"]
                    self.param["uid"] = sharedInstance.header["uid"]
                
                    self.request.request(type: "DELETE", param: self.param,add: "events/"+String(describing: self.events[indexPath.row]["id"]), callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            if User["status"] == 200 {
                                self.refresh()
                            }
                            else {
                                SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                            }
                        }
                        else {
                            SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                        }
                    });
                }
                alertView.addButton("non") {
                    
                }
                alertView.showError("Supprimer", subTitle: "Souhaitez-vous supprimer cet évènement ?")
            }
            shareAction2.backgroundColor = UIColor.red
            return [shareAction2]
        }
        else {
            return []
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventProfilVC"){
            let indexPath = events_list.indexPath(for: sender as! UITableViewCell)
            //            let currentCell = events_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destination as! ProfilEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(describing: events[indexPath!.row]["id"])
            secondViewController.rights = String(describing: events[indexPath!.row]["rights"])
        }
    }
}

class EventOfAssoTableViewCell: UITableViewCell {
    static let identifier = "ManageDemandTableViewCellIdentifier"
    
    private var profileImage: UIImageView?
    private var nameLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        self.configureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView() {
        self.accessoryType = .disclosureIndicator
        
        self.profileImage = UIImageView()
        self.profileImage?.layer.cornerRadius = 15.0
        self.profileImage?.layer.masksToBounds = true
        self.addSubview(self.profileImage!)
        self.profileImage?.snp.makeConstraints({ (make) in
            make.height.width.equalTo(40.0)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10.0)
        })
        
        self.nameLabel = UILabel()
        self.nameLabel?.adjustsFontSizeToFitWidth = true
        self.nameLabel?.textColor = UIColor.black
        self.addSubview(self.nameLabel!)
        self.nameLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(30.0)
            make.width.equalTo(200.0)
            make.centerY.equalTo(self)
            make.left.equalTo(self.profileImage!.snp.right).offset(10.0)
        })
    }
    
    func setCell(pathImage: String, name: String) {
        self.nameLabel?.text = name
        self.profileImage?.downloadedFrom(link: pathImage, contentMode: .scaleToFill)
    }
}

