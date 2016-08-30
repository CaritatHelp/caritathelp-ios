//
//  CustomCellActu.swift
//  Caritathelp
//
//  Created by Jeremy gros on 30/08/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellActu: UITableViewCell {
    

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setCell(NameLabel: String, DateLabel: String, imageName: String, content: String){
        self.titre.text = NameLabel
        self.date.text = DateLabel
        self.photo.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2
        self.photo.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.photo.layer.masksToBounds = true
        self.photo.clipsToBounds = true
        self.content.text = content
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}