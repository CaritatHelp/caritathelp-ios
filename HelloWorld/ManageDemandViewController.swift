//
//  ManageDemandViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 07/01/2017.
//  Copyright © 2017 Jeremy gros. All rights reserved.
//

import UIKit
import SnapKit
import SCLAlertView
import SwiftyJSON

class ManageDemandViewController: UIViewController {
    
    fileprivate var demandTableView: UITableView?
    private var changeModeButton: UIButton?
    var user : JSON = []
    var list_demand : JSON = []
    var request = RequestModel()
    var TitleAssoc = ""
    var AssocID : String = ""
    var EventID: String = ""
    var param = [String: String]()
    var searching = "get"
    var titleSearching = "envoyées"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AssociationProfil.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Demandes"
        self.changeModeButton = UIButton()
        self.changeModeButton?.setTitle(self.titleSearching, for: .normal)
        self.changeModeButton?.setTitleColor(UIColor.GreenBasicCaritathelp(), for: .normal)
        self.changeModeButton?.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        self.changeModeButton?.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 30.0)
        let barButtonItem = UIBarButtonItem(customView: self.changeModeButton!)
        self.navigationItem.setRightBarButton(barButtonItem, animated: true)
        
        self.demandTableView = UITableView()
        self.demandTableView?.register(ManageDemandTableViewCell.self, forCellReuseIdentifier: ManageDemandTableViewCell.identifier)
        self.demandTableView?.delegate = self
        self.demandTableView?.dataSource = self
        self.demandTableView?.backgroundColor = UIColor.white
        self.demandTableView?.addSubview(self.refreshControl)
        self.demandTableView?.tableFooterView = UIView()
        self.view.addSubview(self.demandTableView!)
        
        self.demandTableView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        
        self.refresh()
    }

    func refresh() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        self.param["assoc_id"] = self.AssocID
        
        var val = ""
        if self.searching == "get" {
            val = "membership/waiting"
        }
        else {
            val = "membership/invited"
        }
        
        self.request.request(type: "GET", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                if User["status"] == 200 {
                    self.list_demand = User["response"]
                    self.demandTableView?.reloadData()
                    self.refreshControl.endRefreshing()
                }
                else {
                    SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                }
            }
            else {
            }
        });
    }
    
    func changeMode() {
        if self.searching == "get" {
            self.searching = "send"
            self.titleSearching = "demandes"
            self.title = "Envoyées"
        }
        else {
            self.searching = "get"
            self.titleSearching = "envoyées"
            self.title = "Demandes"
        }
        self.changeModeButton?.setTitle(self.titleSearching, for: .normal)
        self.refresh()
    }
}

extension ManageDemandViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension ManageDemandViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.list_demand.count == 0 {
            if self.searching == "get" {
                self.demandTableView?.backgroundView = NoDataLabel("Aucune invitation reçue")
            }
            else {
                self.demandTableView?.backgroundView = NoDataLabel("Aucune invitation envoyée")
            }
        }
        else {
            self.demandTableView?.backgroundView = NoDataLabel("")
        }
        return self.list_demand.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ManageDemandTableViewCell.identifier) as! ManageDemandTableViewCell
        
        let path = define.path_picture + String(describing: self.list_demand[indexPath.row]["thumb_path"])
        let name = String(describing: self.list_demand[indexPath.row]["fullname"])
        
        cell.setCell(pathImage: path, name: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //bouton Ajouter en ami
        let acceptButton = UITableViewRowAction(style: .normal, title: "Accepter") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.param["notif_id"] = String(describing: self.list_demand[indexPath.row]["notif_id"])
            self.param["acceptance"] = "true"
            let val = "membership/reply_member"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        SCLAlertView().showSuccess("Succès", subTitle: String(describing: User["message"]))
                        self.refresh()
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            })
            
        }
        //bouton kick un membre
        let refusedButton = UITableViewRowAction(style: .normal, title: "Refuser") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.param["notif_id"] = String(describing: self.list_demand[indexPath.row]["notif_id"])
            self.param["acceptance"] = "false"
            let val = "membership/reply_member"
            self.request.request(type: "DELETE", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        SCLAlertView().showSuccess("Succès", subTitle: String(describing: User["message"]))
                        self.refresh()
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            })
        }

        //bouton kick un membre
        let cancelButton = UITableViewRowAction(style: .normal, title: "annuler") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            self.param["volunteer_id"] = String(describing: self.list_demand[indexPath.row]["id"])
            self.param["assoc_id"] = self.AssocID
            let val = "membership/uninvite"
            self.request.request(type: "DELETE", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        SCLAlertView().showSuccess("Succès", subTitle: String(describing: User["message"]))
                        self.refresh()
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            })
        }
        
        acceptButton.backgroundColor = UIColor(red: 50.0/255, green: 150.0/255, blue: 65.0/255, alpha: 1.0)
        refusedButton.backgroundColor = UIColor.red
        cancelButton.backgroundColor = UIColor.red
        
        if self.searching == "get" {
            return [acceptButton, refusedButton]
        }else {
            return [cancelButton]
        }
    }

}

class ManageDemandTableViewCell: UITableViewCell {
    static let identifier = "ManageDemandTableViewCellIdentifier"
    
    private var profileImage: UIImageView?
    private var nameLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.accessoryType = .disclosureIndicator
        
        self.profileImage = UIImageView()
        self.profileImage?.layer.cornerRadius = 15.0
        self.addSubview(self.profileImage!)
        self.profileImage?.snp.makeConstraints({ (make) in
            make.height.width.equalTo(30.0)
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
