//
//  CustomCellInviteGuest.swift
//  Caritathelp
//
//  Created by Jeremy gros on 26/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellInviteGuest: UITableViewCell {
    
    static var identifier = "guestCell"
    
    fileprivate var ImageProfilFriends: UIImageView?
    fileprivate var NameFriends: UILabel?
    //@IBOutlet weak var DetailFriends: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.ImageProfilFriends = UIImageView()
        self.addSubview(self.ImageProfilFriends!)
        self.ImageProfilFriends?.snp.makeConstraints({ (make) in
            make.height.width.equalTo(34.0)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10.0)
        })
        
        self.NameFriends = UILabel()
        self.NameFriends?.adjustsFontSizeToFitWidth = true
        self.addSubview(self.NameFriends!)
        self.NameFriends?.snp.makeConstraints({ (make) in
            make.height.equalTo(34.0)
            make.width.equalTo(200.0)
            make.centerY.equalTo(self)
            make.left.equalTo(self.ImageProfilFriends!.snp.right).offset(10.0)
        })
        
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
    
    func setCell(NameLabel: String, imageName: String){
        //self.TitleNews.text = NameLabel
        //self.DateNews.text = DateLabel
        self.ImageProfilFriends?.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.ImageProfilFriends?.layer.cornerRadius = (self.ImageProfilFriends?.frame.size.width)! / 2
        self.ImageProfilFriends?.layer.borderColor = UIColor.darkGray.cgColor;
        self.ImageProfilFriends?.layer.masksToBounds = true
        self.ImageProfilFriends?.clipsToBounds = true
        self.NameFriends?.text = NameLabel
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
}
