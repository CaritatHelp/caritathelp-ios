//
//  CustomCellProfil.swift
//  Caritathelp
//
//  Created by Jeremy gros on 08/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellProfilVolunteer: UITableViewCell {
    
    @IBOutlet weak var imgProfilVol: UIImageView!
    
    @IBOutlet weak var BtnAddFriend: UIButton!
    
    @IBOutlet weak var NomVolunteer: UILabel!
    
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
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String){
        //self.TitleNews.text = NameLabel
        //self.DateNews.text = DateLabel
        
        self.BtnAddFriend.layer.cornerRadius = self.BtnAddFriend.frame.size.width / 2
        self.BtnAddFriend.layer.borderColor = UIColor.whiteColor().CGColor;
        self.BtnAddFriend.layer.borderWidth = 1.0
        //self.BtnAddFriend.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.BtnAddFriend.layer.masksToBounds = true
        self.BtnAddFriend.clipsToBounds = true
        
        
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
        
    }
}
