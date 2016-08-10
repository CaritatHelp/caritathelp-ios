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
    var alreadyMember = ""
    var user : JSON = []
    
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
    @IBAction func JoinAsso(sender: AnyObject) {
        if(alreadyMember == "none" || alreadyMember == "null"){
        param["token"] = String(user["token"])
        param["assoc_id"] = AssoID
        let val = "membership/join"
        request.request("POST", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                SCLAlertView().showTitle(
                    "Demande envoyé", // Title of view
                    subTitle: "Vous receverez une notification concernant le retour de l'association", // String of view
                    duration: 10.0, // Duration to show before closing automatically, default: 0.0
                    completeText: "ok", // Optional button value, default: ""
                    style: .Success, // Styles - see below.
                    colorStyle: 0x22B573,
                    colorTextButton: 0xFFFFFF
                )
                self.JoinBtn.hidden = true
            }
            else {
                
            }
        });
        }
        else if (alreadyMember == "owner"){
            SCLAlertView().showError("Attention", subTitle: "Vous avez créé cette assocation \n vous ne pouvez la quitter!")

        }

    }
    
    func setCell(User: JSON, assoId: String, rights: String, imagePath: String){
        user = User
        AssoID = assoId
        alreadyMember = rights
        let notJoined = UIImage(named: "asso_not_joined")
        let Joined = UIImage(named: "asso_joined")
        let waiting = UIImage(named: "waiting")
        self.imageProfil.downloadedFrom(link: imagePath, contentMode: .ScaleToFill)
        self.imageProfil.layer.cornerRadius = self.imageProfil.frame.size.width / 2;
        self.imageProfil.layer.borderWidth = 1.0
        self.imageProfil.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.imageProfil.layer.masksToBounds = true
        self.imageProfil.clipsToBounds = true
        
        self.JoinBtn.layer.cornerRadius = self.JoinBtn.frame.size.width / 2;
        self.JoinBtn.layer.borderWidth = 1.0
        self.JoinBtn.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.JoinBtn.layer.shadowOffset = CGSize(width: self.JoinBtn.frame.size.width + 10.0, height: self.JoinBtn.frame.size.height + 10.0)
        self.JoinBtn.layer.shadowOpacity = 0.7
        self.JoinBtn.layer.shadowColor = UIColor.blackColor().CGColor
        self.JoinBtn.layer.shadowRadius = self.JoinBtn.frame.size.width / 2;
        self.JoinBtn.layer.masksToBounds = true
        self.JoinBtn.clipsToBounds = true
        
                print(alreadyMember)
        if (alreadyMember == "none" || alreadyMember == "null"){
            //self.JoinBtn.hidden = false
            JoinBtn.setImage(notJoined, forState: .Normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)

        }
        else if alreadyMember == "waiting"{
            //JoinBtn.hidden = true
            JoinBtn.setImage(waiting, forState: .Normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)
        }
        else{
            //self.JoinBtn.hidden = true
            JoinBtn.setImage(Joined, forState: .Normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)
            //JoinBtn.hidden = false
        }
       

    }
}
