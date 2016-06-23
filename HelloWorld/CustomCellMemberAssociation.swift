//
//  CustomCellMemberAssociation.swift
//  Caritathelp
//
//  Created by Jeremy gros on 22/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellMemberAsso: UITableViewCell {
    
    @IBOutlet weak var ProfilePictureMember: UIImageView!
    @IBOutlet weak var NameMember: UILabel!
    
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
    
    func setCell(NameLabel: String, imageName: String){
        self.NameMember.text = NameLabel
        self.ProfilePictureMember.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
        self.ProfilePictureMember.layer.cornerRadius = 30
        self.ProfilePictureMember.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.ProfilePictureMember.layer.masksToBounds = true
        self.ProfilePictureMember.clipsToBounds = true
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}