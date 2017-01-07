//
//  CustomCellHeaderAsso.swift
//  Caritathelp
//
//  Created by Jeremy gros on 07/04/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class CustomCellHeaderAsso: UITableViewCell {
    
    @IBOutlet weak var imageProfil: UIImageView!
    @IBOutlet weak var JoinBtn: UIButton!
    var request = RequestModel()
    var param = [String: String]()
    var AssoID = ""
    var Asso : JSON =  []
    var alreadyMember = ""
    var user : JSON = []
    let notJoined = UIImage(named: "asso_not_joined")
    let Joined = UIImage(named: "asso_joined")
    let waiting = UIImage(named: "waiting")

    var showgallery: ((CustomCellHeaderAsso) -> Void)?
    
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
    
    @IBAction func JoinAsso(_ sender: AnyObject) {
        if(alreadyMember == "none" || alreadyMember == "null"){
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            self.param["assoc_id"] = AssoID
            let val = "membership/join"
            request.request(type: "POST", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if User["status"] == 200 {
                        self.alreadyMember = "waiting"
                        SCLAlertView().showTitle(
                            "Demande envoyée", // Title of view
                            subTitle: "Vous receverez une notification concernant le retour de l'association", // String of view
                            duration: 10.0, // Duration to show before closing automatically, default: 0.0
                            completeText: "ok", // Optional button value, default: ""
                            style: .success, // Styles - see below.
                            colorStyle: 0x22B573,
                            colorTextButton: 0xFFFFFF
                        )
                        self.JoinBtn.setImage(self.waiting, for: .normal)
                    }
                    else {
                        SCLAlertView().showError("Attention", subTitle: String(describing: User["message"]))
                    }
                }
                else {
                    SCLAlertView().showError("Attention", subTitle: "une erreuere est survenue...")
                }
            });
        }
        else if (alreadyMember == "owner"){
            SCLAlertView().showError("Attention", subTitle: "Vous avez créé cette assocation \n vous ne pouvez la quitter!")
        }
        else if (alreadyMember == "waiting"){
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
                self.param["assoc_id"] = self.AssoID
                self.request.request(type: "DELETE", param: self.param,add: "membership/unjoin", callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        if User["status"] == 200 {
                            self.alreadyMember = "none"
                            self.JoinBtn.setImage(self.notJoined, for: .normal)
                        }
                        else {
                            SCLAlertView().showError("Attention", subTitle: String(describing: User["message"]))
                        }
                    }
                    else {
                        
                    }
                });
            }
            alertView.addButton("non") {
                
            }
            alertView.showError("Annuler", subTitle: "Souhaitez-vous annuler votre demande pour rejoindre cette association ?")
        }
        
    }
    
    func actionGallery() {
        self.showgallery?(self)
    }
    
    func setCell(User: JSON, assoId: String, rights: String, imagePath: String){
        self.user = User
        self.AssoID = assoId
        self.alreadyMember = rights
        self.imageProfil.downloadedFrom(link: imagePath, contentMode: .scaleToFill)
        self.imageProfil.layer.cornerRadius = self.imageProfil.frame.size.width / 2;
        self.imageProfil.layer.borderWidth = 1.0
        self.imageProfil.layer.borderColor = UIColor.lightGray.cgColor;
        self.imageProfil.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.imageProfil.layer.shadowOpacity = 0.4
        self.imageProfil.layer.shadowColor = UIColor.black.cgColor
        self.imageProfil.layer.masksToBounds = false
        self.imageProfil.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(actionGallery))
        self.imageProfil.isUserInteractionEnabled = true
        self.imageProfil.addGestureRecognizer(tapGestureRecognizer)
        
        self.JoinBtn.layer.cornerRadius = self.JoinBtn.frame.size.width / 2;
        self.JoinBtn.layer.borderWidth = 1.0
        self.JoinBtn.layer.borderColor = UIColor.lightGray.cgColor;
        self.JoinBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.JoinBtn.layer.shadowOpacity = 0.4
        self.JoinBtn.layer.shadowColor = UIColor.black.cgColor
        //self.JoinBtn.layer.shadowRadius = self.JoinBtn.frame.size.width / 2;
        self.JoinBtn.layer.masksToBounds = false
        
        print("MEMBER ? " + alreadyMember)
        if (alreadyMember == "none" || alreadyMember == "null"){
            //self.JoinBtn.hidden = false
            JoinBtn.setImage(self.notJoined, for: .normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)

        }
        else if alreadyMember == "waiting"{
            //JoinBtn.hidden = true
            JoinBtn.setImage(self.waiting, for: .normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)
        }
        else{
            //self.JoinBtn.hidden = true
            JoinBtn.setImage(self.Joined, for: .normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)
        }
       

    }
}
