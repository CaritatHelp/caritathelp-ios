//
//  CustomCellHomePage.swift
//  Caritathelp
//
//  Created by Jeremy gros on 24/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellHomePage: UITableViewCell {
    
    @IBOutlet weak var ImageProfilNews: UIImageView!
    @IBOutlet weak var TitleNews: UILabel!
    @IBOutlet weak var DateNews: UILabel!
    
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var ContentNews: UITextView!
    @IBOutlet weak var FaireSavoirBtn: UIButton!
    @IBOutlet weak var CommenterBtn: UIButton!
    
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
    
    func setCell(NameLabel: String, DateLabel: String, imageName: String, content: String){
        self.TitleNews.text = NameLabel
        self.DateNews.text = DateLabel
        self.ImageProfilNews.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
        self.ImageProfilNews.layer.cornerRadius = self.ImageProfilNews.frame.size.width / 2
        self.ImageProfilNews.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.ImageProfilNews.layer.masksToBounds = true
        self.ImageProfilNews.clipsToBounds = true
        self.Content.text = content
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}
