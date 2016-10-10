//
//  CustomCellMyAssociations.swift
//  Caritathelp
//
//  Created by Jeremy gros on 22/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellMyEvents: UITableViewCell {
    

    @IBOutlet weak var PictureAsso: UIImageView!
    @IBOutlet weak var NameAsso: UILabel!
    @IBOutlet weak var LieuAsso: UILabel!
    
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
    
    func setCell(NameLabel: String, imageName: String, state: String){
        self.NameAsso.text = NameLabel
        print("name :" + imageName + ":")
        if (imageName == "null") {
            self.PictureAsso.image = UIImage(named: "default_profil")
        }else {
            self.PictureAsso.downloadedFrom(link: define.path_picture + imageName, contentMode: .scaleToFill)
        }
        self.PictureAsso.layer.cornerRadius = 10
        self.PictureAsso.layer.borderColor = UIColor.darkGray.cgColor;
        self.PictureAsso.layer.masksToBounds = true
        self.PictureAsso.clipsToBounds = true
        self.LieuAsso.text = state
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}
