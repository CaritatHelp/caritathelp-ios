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
        param["token"] = String(user["token"])
        param["assoc_id"] = AssoID
        let val = "membership/join"
        request.request("POST", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.JoinBtn.hidden = true
            }
            else {
                
            }
        });

    }
    
    func setCell(User: JSON, assoId: String, rights: String){
        user = User
        AssoID = assoId
        alreadyMember = rights
        let notJoined = UIImage(named: "asso_not_joined")
        let Joined = UIImage(named: "asso_joined")
        self.imageProfil.layer.cornerRadius = self.imageProfil.frame.size.width / 2;
        self.imageProfil.layer.borderWidth = 1.0
        self.imageProfil.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.imageProfil.layer.masksToBounds = true
        self.imageProfil.clipsToBounds = true
        
        self.JoinBtn.layer.cornerRadius = self.JoinBtn.frame.size.width / 2;
        self.JoinBtn.layer.borderWidth = 1.0
        self.JoinBtn.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.JoinBtn.layer.masksToBounds = true
        self.JoinBtn.clipsToBounds = true
                print(alreadyMember)
        if (alreadyMember == "none" || alreadyMember == "null"){
            //self.JoinBtn.hidden = false
            JoinBtn.setImage(notJoined, forState: .Normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(75,75,75,75)

        }
        else{
            //self.JoinBtn.hidden = true
            JoinBtn.setImage(Joined, forState: .Normal)
            JoinBtn.imageEdgeInsets = UIEdgeInsetsMake(50,50,50,50)

        }
       

    }
}
