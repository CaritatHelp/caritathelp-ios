//
//  InviteGuest.swift
//  Caritathelp
//
//  Created by Jeremy gros on 26/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView
import SnapKit

class InviteGuestController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user : JSON = []
    var EventID = ""
    var AssoID = ""
    var request = RequestModel()
    var param = [String: String]()
    var friends : JSON = []
    var selectedUser:Array< JSON > = Array < JSON >()
    fileprivate var sendButton: UIButton?
    
    fileprivate var friends_list: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Participants"
        self.sendButton = UIButton()
        self.sendButton?.setTitle("inviter", for: .normal)
        self.sendButton?.setTitleColor(UIColor.GreenBasicCaritathelp(), for: .normal)
        self.sendButton?.addTarget(self, action: #selector(InviteMember), for: .touchUpInside)
        self.sendButton?.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 30.0)
        let barButtonItem = UIBarButtonItem(customView: self.sendButton!)
        self.navigationItem.setRightBarButton(barButtonItem, animated: true)

        
        self.friends_list = UITableView()
        self.friends_list?.delegate = self
        self.friends_list?.dataSource = self
        self.friends_list?.backgroundColor = UIColor.white
        self.friends_list?.tableFooterView = UIView()
        self.friends_list?.register(CustomCellInviteGuest.self, forCellReuseIdentifier: CustomCellInviteGuest.identifier)
        self.view.addSubview(self.friends_list!)
        self.friends_list?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "associations/" + AssoID + "/members"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User["response"]
                self.friends_list?.reloadData()
                
            }
            else {
                
            }
        });
        
    }
    
    func InviteMember(_ sender: AnyObject) {
        var i = 0
        
        while i < self.selectedUser.count {
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            self.param["volunteer_id"] = String(describing: selectedUser[i]["id"])
            self.param["event_id"] = EventID
            let val = "guests/invite"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    print("invitation envoyé")
                    //print("membre inviter : " + String(describing: self.selectedUser[i]["firstname"]))
                }
                else {
                    print("n'a pas pu etre inviter")
                }
            });
            i += 1
        }
        
//        while i < self.friends.count {
//            let rowToSelect = IndexPath(forRow: i, inSection: 0)
//            print("sender = \(sender.indexPath)")
//            if let cell = self.friends_list?.cellForRow(at: sender.indexPath as IndexPath) {
//            
//            if (cell.accessoryType == .checkmark){
//                print("invite" + String(describing: friends[i]["firstname"]))
//                
//                self.param["access-token"] = sharedInstance.header["access-token"]
//                self.param["client"] = sharedInstance.header["client"]
//                self.param["uid"] = sharedInstance.header["uid"]
//                self.param["volunteer_id"] = String(describing: friends[i]["id"])
//                self.param["event_id"] = EventID
//                let val = "guests/invite"
//                self.request.request(type: "POST", param: self.param,add: val, callback: {
//                    (isOK, User)-> Void in
//                    if(isOK){
//                        print("membre inviter : " + String(describing: self.friends[i]["firstname"]))
//                    }
//                    else {
//                        print("n'a pas pu etre inviter")
//                    }
//                });
//                
//                
//            }
//            }
//            i += 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.friends_list?.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath as IndexPath) as! CustomCellInviteGuest

        let name = String(describing: self.friends[indexPath.row]["firstname"]) + " " + String(describing: friends[indexPath.row]["lastname"])
        cell.setCell(NameLabel: name, imageName: define.path_picture + String(describing: friends[indexPath.row]["thumb_path"]))
        cell.selectionStyle = .none
        cell.tintColor = UIColor.GreenBasicCaritathelp()
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = self.friends_list?.cellForRow(at: indexPath as IndexPath)

        if (cell?.accessoryType == .checkmark){
            cell!.accessoryType = .none;
            var i = 0
            while i < self.selectedUser.count {
                if String(describing: self.selectedUser[i]["id"]) == String(describing: self.friends[indexPath.row]["id"]) {
                    print("\(self.selectedUser[i]["id"])")
                    self.selectedUser.remove(at: i)
                }
                i += 1
            }
        }else{
            self.selectedUser.append(self.friends[indexPath.row])
            cell!.accessoryType = .checkmark;
            
        }
    }
}
