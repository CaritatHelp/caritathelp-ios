//
//  CustomCellProfil.swift
//  Caritathelp
//
//  Created by Jeremy gros on 08/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView
import SwiftyJSON

class CustomCellProfilVolunteer: UITableViewCell {
    
    @IBOutlet weak var imgProfilVol: UIImageView!
    
    @IBOutlet weak var BtnAddFriend: UIButton!
    
    @IBOutlet weak var NomVolunteer: UILabel!
    @IBOutlet weak var ModifyPictureBtn: UIButton!
    @IBOutlet weak var AccceptFriendBtn: UIButton!
    @IBOutlet weak var RefusedFriendBtn: UIButton!
    
    var user: JSON = []
    var request = RequestModel()
    var param = [String: String]()
    
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
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String, User: JSON){
        //self.TitleNews.text = NameLabel
        //self.DateNews.text = DateLabel
        AccceptFriendBtn.hidden = true
        RefusedFriendBtn.hidden = true
        user = User
        if (user["id"] == sharedInstance.volunteer["response"]["id"]){
            BtnAddFriend.hidden = true
        }else {
            if (DetailLabel == "friend"){
                let alreadyAccept = UIImage(named: "reviewer-1")
                BtnAddFriend.setImage(alreadyAccept, forState: .Normal)
                BtnAddFriend.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)
            }else if (DetailLabel == "invitation sent"){
                let alreadyAccept = UIImage(named: "hourglass")
                BtnAddFriend.setImage(alreadyAccept, forState: .Normal)
                BtnAddFriend.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)
            }else if (DetailLabel == "invitation received") {
                AccceptFriendBtn.hidden = false
                RefusedFriendBtn.hidden = false
                BtnAddFriend.hidden = true
            }
            self.BtnAddFriend.layer.cornerRadius = self.BtnAddFriend.frame.size.width / 2
            self.BtnAddFriend.layer.borderColor = UIColor.whiteColor().CGColor;
            self.BtnAddFriend.layer.borderWidth = 1.0
            //self.BtnAddFriend.layer.borderColor = UIColor.darkGrayColor().CGColor;
            self.BtnAddFriend.layer.masksToBounds = true
            self.BtnAddFriend.clipsToBounds = true
        }
        
        imgProfilVol.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
                self.imgProfilVol.layer.cornerRadius = self.imgProfilVol.frame.size.width / 2
                self.imgProfilVol.layer.borderColor = UIColor.darkGrayColor().CGColor;
        
        self.imgProfilVol.layer.borderWidth = 1.0
        self.imgProfilVol.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.imgProfilVol.layer.shadowOffset = CGSize(width: self.imgProfilVol.frame.size.width + 10.0, height: self.imgProfilVol.frame.size.height + 10.0)
        self.imgProfilVol.layer.shadowOpacity = 0.7
        self.imgProfilVol.layer.shadowColor = UIColor.blackColor().CGColor
        self.imgProfilVol.layer.shadowRadius = self.imgProfilVol.frame.size.width / 2;
        
                self.imgProfilVol.layer.masksToBounds = true
                self.imgProfilVol.clipsToBounds = true
        
        NomVolunteer.text = NameLabel
                
    }
    
    @IBAction func add_friend(sender: AnyObject) {
        
        if (user["friendship"] == "none") {
            self.param["token"] = String(sharedInstance.volunteer["token"])
            self.param["volunteer_id"] = String(user["id"])
            let val = "friendship/add"
            self.request.request("POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    //self.friends = User
                    //self.list_friends.reloadData()
                }
                else {
                    
                }
            });
        }

    }
    @IBAction func Accept_Friend(sender: AnyObject) {
        if (user["friendship"] == "none") {
            self.param["token"] = String(sharedInstance.volunteer["token"])
            self.param["notif_id"] = String(user["response"]["id"])
            let val = "friendship/reply"
            self.request.request("POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    //self.friends = User
                    //self.list_friends.reloadData()
                }
                else {
                    
                }
            });
        }
    }
}
