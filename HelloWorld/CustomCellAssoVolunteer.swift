//
//  CustomCellAssoVolunteer.swift
//  Caritathelp
//
//  Created by Jeremy gros on 09/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellAssoVolunteer: UITableViewCell {
    
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
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(NameLabel: String, imageName: String, state: String){
        self.NameAsso.text = NameLabel
        self.PictureAsso.layer.cornerRadius = 10
        self.PictureAsso.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.PictureAsso.layer.masksToBounds = true
        self.PictureAsso.clipsToBounds = true
        self.LieuAsso.text = state
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}
