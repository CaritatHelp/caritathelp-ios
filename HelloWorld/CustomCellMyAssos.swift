//
//  CustomCellMyEvents.swift
//  Caritathelp
//
//  Created by Jeremy gros on 22/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellMyAsso: UITableViewCell {
    
    
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
        self.PictureAsso.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.PictureAsso.layer.cornerRadius = 10
        self.PictureAsso.layer.borderWidth = 1.0
        self.PictureAsso.layer.borderColor = UIColor.darkGray.cgColor;
        self.PictureAsso.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.PictureAsso.layer.shadowOpacity = 0.4
        self.PictureAsso.layer.shadowColor = UIColor.black.cgColor
        self.PictureAsso.layer.masksToBounds = false
        self.PictureAsso.clipsToBounds = true
        self.LieuAsso.text = state
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}
