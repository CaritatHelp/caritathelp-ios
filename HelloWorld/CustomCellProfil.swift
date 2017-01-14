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
    var rights = ""
    
    var showgallery: ((CustomCellProfilVolunteer) -> Void)?
    
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
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String, User: JSON){
        //self.TitleNews.text = NameLabel
        //self.DateNews.text = DateLabel
        AccceptFriendBtn.isHidden = true
        RefusedFriendBtn.isHidden = true
        self.BtnAddFriend.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        self.BtnAddFriend.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.BtnAddFriend.layer.shadowOpacity = 0.5
        self.BtnAddFriend.layer.shadowRadius = 25.0
        user = User
        rights = String(describing: user["friendship"])
        if (user["id"] == sharedInstance.volunteer["response"]["id"]){
            BtnAddFriend.isHidden = true
            ModifyPictureBtn.isHidden = false
        }else {
            ModifyPictureBtn.isHidden = true
            if (DetailLabel == "friend"){
                let alreadyAccept = UIImage(named: "reviewer-1")
                BtnAddFriend.setImage(alreadyAccept, for: .normal)
            }else if (DetailLabel == "invitation sent"){
                let alreadyAccept = UIImage(named: "hourglass")
                BtnAddFriend.setImage(alreadyAccept, for: .normal)
            }else if (DetailLabel == "invitation received") {
                AccceptFriendBtn.isHidden = false
                RefusedFriendBtn.isHidden = false
                BtnAddFriend.isHidden = true
            }
            self.BtnAddFriend.layer.cornerRadius = self.BtnAddFriend.frame.size.width / 2
            self.BtnAddFriend.layer.borderColor = UIColor.white.cgColor;
            self.BtnAddFriend.layer.borderWidth = 1.0
            //self.BtnAddFriend.layer.borderColor = UIColor.darkGrayColor().CGColor;
            self.BtnAddFriend.layer.masksToBounds = true
            self.BtnAddFriend.clipsToBounds = true
        }
        
        imgProfilVol.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.imgProfilVol.layer.cornerRadius = self.imgProfilVol.frame.size.width / 2
        self.imgProfilVol.layer.borderColor = UIColor.darkGray.cgColor;
        
        self.imgProfilVol.layer.borderWidth = 1.0
        self.imgProfilVol.layer.borderColor = UIColor.darkGray.cgColor;
        self.imgProfilVol.layer.shadowOffset = CGSize(width: self.imgProfilVol.frame.size.width + 10.0, height: self.imgProfilVol.frame.size.height + 10.0)
        self.imgProfilVol.layer.shadowOpacity = 0.7
        self.imgProfilVol.layer.shadowColor = UIColor.black.cgColor
        self.imgProfilVol.layer.shadowRadius = self.imgProfilVol.frame.size.width + 10 / 2;
        
        self.imgProfilVol.layer.masksToBounds = true
        self.imgProfilVol.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(actionGallery))
        self.imgProfilVol.isUserInteractionEnabled = true
        self.imgProfilVol.addGestureRecognizer(tapGestureRecognizer)
        NomVolunteer.text = NameLabel
        
    }
    
    func actionGallery() {
        self.showgallery?(self)
    }
    
    @IBAction func add_friend(_ sender: AnyObject) {
        print("\(user)")
        if (rights == "none" || rights == "null") {
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            self.param["volunteer_id"] = String(describing: user["id"])
            let val = "friendship/add"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        let newimage = UIImage(named: "hourglass")
                        self.BtnAddFriend.setImage(newimage?.resizeImage(newWidth: 30.0), for: .normal)
                    }
                    else {
                        SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    
                }
            });
        }
        else if rights == "invitation sent" {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false,
                showCircularIcon: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("oui") {
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                self.param["notif_id"] = String(describing: self.user["notif_id"])
                let val = "friendship/cancel_request"
                self.request.request(type: "DELETE", param: self.param,add: val, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        if User["status"] == 200 {
                            let newimage = UIImage(named: "add_user-2")
                            self.BtnAddFriend.setImage(newimage?.resizeImage(newWidth: 30.0), for: .normal)
                            self.rights = "null"
                        }
                        else {
                            SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                        }
                    }
                    else {
                        
                    }
                });            }
            alertView.addButton("non") {
                
            }
            alertView.showError("Annuler", subTitle: "Souhaitez-vous annuler cette invitation?")
        }
        else {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false,
                showCircularIcon: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("oui") {
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                self.param["volunteer_id"] = String(describing: self.user["id"])
                let val = "friendship/remove"
                self.request.request(type: "DELETE", param: self.param,add: val, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        if User["status"] == 200 {
                            let newimage = UIImage(named: "add_user-2")
                            self.BtnAddFriend.setImage(newimage?.resizeImage(newWidth: 30.0), for: .normal)
                            self.rights = "null"
                        }
                        else {
                            SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                        }
                    }
                    else {
                        
                    }
                });            }
            alertView.addButton("non") {
                
            }
            alertView.showError("Supprimer", subTitle: "Vous souhaitez supprimer cet amitié?")
        }

    }
    @IBAction func Accept_Friend(_ sender: AnyObject) {
        if (user["friendship"] == "invitation received") {
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            self.param["notif_id"] = String(describing: user["notif_id"])
            self.param["acceptance"] = "true"
            let val = "friendship/reply"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.AccceptFriendBtn.isHidden = true
                    self.RefusedFriendBtn.isHidden = true
                    self.BtnAddFriend.setImage(UIImage(named: "reviewer-1"), for: .normal)
                    self.BtnAddFriend.isHidden = false
                    self.rights = "friend"
                }
                else {
                    SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                }
            });
        }
    }
    @IBAction func refused_friend(_ sender: AnyObject) {
        if (user["friendship"] == "invitation received") {
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            self.param["notif_id"] = String(describing: user["notif_id"])
            self.param["acceptance"] = "false"
            let val = "friendship/reply"
            self.request.request(type: "POST", param: self.param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                     self.AccceptFriendBtn.isHidden = true
                    self.RefusedFriendBtn.isHidden = true
                    self.BtnAddFriend.setImage(UIImage(named: "add-user-2"), for: .normal)
                     self.BtnAddFriend.isHidden = false
                    //self.friends = User
                    //self.list_friends.reloadData()
                    self.rights = "none"
                }
                else {
                    SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                }
            });
        }
    }
}
