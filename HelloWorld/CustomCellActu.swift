//
//  CustomCellActu.swift
//  Caritathelp
//
//  Created by Jeremy gros on 30/08/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class CustomCellActu: UITableViewCell {
    

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var btn_setting: UIButton!
    
    var tapped_modify: ((CustomCellActu, String) -> Void)?
    var tapped_delete: ((CustomCellActu, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func setting_actu(sender: AnyObject) {
        // Initialize SCLAlertView using custom Appearance
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,216,70))
        let x = (subview.frame.width - 180) / 2
        
        // Add textfield 1
        let textfield1 = UITextView(frame: CGRectMake(x,10,180,50))
        textfield1.layer.borderColor = UIColor.blueColor().CGColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.text = content.text
        textfield1.textAlignment = NSTextAlignment.Center
        subview.addSubview(textfield1)
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        alert.addButton("modifier") {
            self.tapped_modify?(self, textfield1.text)
        }
        alert.addButton("supprimer") {
            self.tapped_delete?(self, textfield1.text)
        }
        alert.addButton("annuler") {
        }
        
        alert.showInfo("Modification", subTitle: "Vous pouvez modifier votre actuailté.")

    }
    
    func setCell(NameLabel: String, DateLabel: String, imageName: String, content: String, from: String){
        self.titre.text = NameLabel
        self.date.text = DateLabel
        self.photo.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2
        self.photo.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.photo.layer.masksToBounds = true
        self.photo.clipsToBounds = true
        self.content.text = content
        
        if from == "false"{
            btn_setting.hidden = true
        }
    }
    
}