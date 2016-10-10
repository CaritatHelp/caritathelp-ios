//
//  CustomCellNotif.swift
//  Caritathelp
//
//  Created by Jeremy gros on 25/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CustomCellNotif: UITableViewCell {
    
    @IBOutlet weak var LabelNotif: UILabel!
    @IBOutlet weak var DetailNotif: UILabel!
    
    @IBOutlet weak var ImageProfilFriends: UIImageView!
    
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
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String){
        //self.TitleNews.text = NameLabel
        //self.DateNews.text = DateLabel
        self.ImageProfilFriends.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.ImageProfilFriends.layer.cornerRadius = 10
        self.ImageProfilFriends.layer.borderColor = UIColor.darkGray.cgColor;
        self.ImageProfilFriends.layer.masksToBounds = true
        self.ImageProfilFriends.clipsToBounds = true
        self.LabelNotif.text = NameLabel
        self.DetailNotif.text = DetailLabel
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
}
