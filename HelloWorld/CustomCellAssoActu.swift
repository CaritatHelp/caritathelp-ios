//
//  CustomCellAssoActu.swift
//  Caritathelp
//
//  Created by Jeremy gros on 27/07/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class CustomCellAssoActu: UITableViewCell {
    
    @IBOutlet weak var imageProfil: UIImageView!
    @IBOutlet weak var titleActu: UILabel!
    @IBOutlet weak var DateActu: UILabel!
    @IBOutlet weak var ContentActu: UILabel!
    
    var request = RequestModel()
    var param = [String: String]()
    var AssoID = ""
    var alreadyMember = ""
    var user : JSON = []
    
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
    
    func setCell(title: String, date: String, content: String, imagePath: String){
        titleActu.text = title
        DateActu.text = date
        ContentActu.text = content
        
        let font = UIFont(name: "Helvetica", size: 20.0)
        
        let height = define.heightForView(text: content, font: font!, width: 100.0)
        ContentActu.frame = CGRect(x:ContentActu.frame.origin.x, y:ContentActu.frame.origin.y, width:ContentActu.frame.width ,height: height)
        
        self.imageProfil.downloadedFrom(link: imagePath, contentMode: .scaleToFill)
        self.imageProfil.layer.cornerRadius = 10
        self.imageProfil.layer.borderWidth = 1.0
        self.imageProfil.layer.borderColor = UIColor.darkGray.cgColor;
        self.imageProfil.layer.masksToBounds = true
        self.imageProfil.clipsToBounds = true

    }

}
