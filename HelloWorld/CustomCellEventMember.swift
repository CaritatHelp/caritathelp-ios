//
//  CustomCellEventMember.swift
//  Caritathelp
//
//  Created by Jeremy gros on 11/04/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellEventMember: UITableViewCell {
    
    @IBOutlet weak var ImageProfilMember: UIImageView!
    @IBOutlet weak var NameMember: UILabel!
    @IBOutlet weak var DetailMember: UILabel!

    
    //INIT A CUSTOM CELL
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
    
    //fin init
    
    //Give value to the cell
    func setCell(NameLabel: String, DetailLabel: String, imageName: String){
        // design de l'image de la cellule
        self.ImageProfilMember.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.ImageProfilMember.layer.cornerRadius = self.ImageProfilMember.frame.size.width / 2
        self.ImageProfilMember.layer.borderColor = UIColor.darkGray.cgColor;
        self.ImageProfilMember.layer.masksToBounds = true
        self.ImageProfilMember.clipsToBounds = true
        
        //nom du membre
        self.NameMember.text = NameLabel
        
        //detail du membre
        self.DetailMember.text = DetailLabel
    }
}
