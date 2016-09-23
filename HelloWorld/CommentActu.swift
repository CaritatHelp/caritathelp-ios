//
//  CommentActu.swift
//  Caritathelp
//
//  Created by Jeremy gros on 19/08/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class CommentActuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var list_actu: UITableView!
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var actu : JSON = []
    var comments : JSON = []
    var IDnews = ""
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CommentActuController.refreshComment), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        let cell = list_actu.dequeueReusableCellWithIdentifier("headerCellNews", forIndexPath: indexPath) as! CustomCellHeaderNews
            var title = ""
            if actu["group_name"] == user["fullname"] {
                title = String(actu["volunteer_name"]) + " a publié sur son mur"
            } else {
                title = String(actu["volunteer_name"]) + " a publié sur le mur de " + String(actu["group_name"])
            }
            
            cell.setCell(title, DateLabel: String(actu["updated_at"]), imageName: define.path_picture + String(actu["volunteer_thumb_path"]), content: String(actu["content"]))
        return cell
        } else if indexPath.row == 1 {
            let cell = list_actu.dequeueReusableCellWithIdentifier("CommentNews", forIndexPath: indexPath) as! CustomCellCommentNews
            cell.tapped = { [unowned self] (selectedCell) -> Void in
                let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                self.refreshListComment()
            }
            cell.setCell(IDnews)
        return cell
        }
        else {
            let cell = list_actu.dequeueReusableCellWithIdentifier("ListcommentsNews", forIndexPath: indexPath) as! CustomCellListCommentsNews
            
            cell.tapped_modify = { [unowned self] (selectedCell, Newcontent) -> Void in
                let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                let selectedItem = self.actu[path.row]["content"]
                
                print("the selected item is \(selectedItem) and new : \(Newcontent)")
                self.param["token"] = String(self.user["token"])
                self.param["content"] = Newcontent
                self.request.request("PUT", param: self.param, add: "comments/" + String(self.comments[path.row - 2]["id"]), callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.refreshListComment()
                    }
                    else {
                        SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                    }
                });
                
            }
            
            cell.tapped_delete = { [unowned self] (selectedCell, Newcontent) -> Void in
                let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                self.param["token"] = String(self.user["token"])
                self.request.request("DELETE", param: self.param, add: "comments/" + String(self.comments[path.row - 2]["id"]) , callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        //self.refreshActu()
                        self.refreshListComment()
                        
                    }
                    else {
                        SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                    }
                });
                
            }
            var from = ""
            if comments[indexPath.row - 2]["volunteer_id"] == user["id"] {
                from = "true"
            }
            else {
                from = "false"
            }
            
            cell.setCell(String(comments[indexPath.row - 2]["firstname"]) + " " + String(comments[indexPath.row - 2]["lastname"]), DateLabel: String(comments[indexPath.row - 2]["updated_at"]), imageName: define.path_picture + String(comments[indexPath.row - 2]["thumb_path"]), content: String(comments[indexPath.row - 2]["content"]), from: from)
        return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //var cell = tableView.cellForRowAtIndexPath(indexPath)
        if indexPath.row == 0 {
            return 214
        } else if indexPath.row == 1 {
            return 46
        }else {
            return 120
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        list_actu.tableFooterView = UIView()
        self.hideKeyboardWhenTappedAround()
        user = sharedInstance.volunteer["response"]
        self.list_actu.addSubview(self.refreshControl)
        
        refreshComment()
        
    }

    func refreshComment() {
        
        param["token"] = String(user["token"])
        request.request("GET", param: param, add: "news/" + IDnews, callback: {
            (isOK, User)-> Void in
            if(isOK){
                //self.refreshActu()
                self.actu = User["response"]
                //self.list_actu.reloadData()
                self.refreshListComment()
                }
            else {
                SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
            }
        });
    }
    
    func refreshListComment() {
        self.request.request("GET", param: self.param, add: "news/" + self.IDnews + "/comments", callback: {
            (isOK, User)-> Void in
            if(isOK){
                //self.refreshActu()
                self.comments = User["response"]
                self.refreshControl.endRefreshing()
                self.list_actu.reloadData()
                
            }
            else {
                SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
            }
        });

    }
    
}

class CustomCellHeaderNews: UITableViewCell {
    
    @IBOutlet weak var ImageProfilNews: UIImageView!
    @IBOutlet weak var TitleNews: UILabel!
    @IBOutlet weak var DateNews: UILabel!
    
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
        self.ContentNews.text = content
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}

class CustomCellCommentNews: UITableViewCell {
    
    var request = RequestModel()
    var param = [String: String]()
    var IDnews = ""
    
    var tapped: ((CustomCellCommentNews) -> Void)?
    
    @IBOutlet weak var TextFieldComments: UITextView!
    
    @IBOutlet weak var BtnComment: UIButton!
    
    @IBAction func Comment(sender: AnyObject) {
        if TextFieldComments.text == "" {
            SCLAlertView().showError("Attention", subTitle: "Votre commentaire est vide.")
        }else {
            param["token"] = String(sharedInstance.volunteer["response"]["token"])
            param["content"] = TextFieldComments.text
            param["new_id"] = IDnews
            self.request.request("POST", param: self.param, add: "comments", callback: {
                (isOK, User)-> Void in
                if(isOK){
                    //self.refreshActu()
                    //self.list_actu.reloadData()
                    print("commentaire envoyé !")
                    self.TextFieldComments.text = ""
                    self.tapped?(self)
                }
                else {
                    SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                }
            });

        }
        
    }
    
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
    
    func setCell(id: String){
        IDnews = id
        
        TextFieldComments.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        TextFieldComments.layer.borderWidth = 1.0;
        TextFieldComments.layer.cornerRadius = 5.0;
        
    }
    
}

class CustomCellListCommentsNews: UITableViewCell {
    
    @IBOutlet weak var ImageProfilNews: UIImageView!
    @IBOutlet weak var TitleNews: UILabel!
    @IBOutlet weak var DateNews: UILabel!
    
    var tapped_modify: ((CustomCellListCommentsNews, String) -> Void)?
    var tapped_delete: ((CustomCellListCommentsNews, String) -> Void)?
    
    @IBOutlet weak var btn_comment: UIButton!
    @IBOutlet weak var ContentNews: UITextView!
    
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
    @IBAction func Comment_setting(sender: AnyObject) {
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
        textfield1.text = ContentNews.text
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
        print("-------- " + NameLabel)
        self.TitleNews.text = NameLabel
        self.DateNews.text = DateLabel
        self.ImageProfilNews.downloadedFrom(link: imageName, contentMode: .ScaleToFill)
        self.ImageProfilNews.layer.cornerRadius = 5
        self.ImageProfilNews.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.ImageProfilNews.layer.masksToBounds = true
        self.ImageProfilNews.clipsToBounds = true
        self.ContentNews.text = content
        
        if from == "false" {
            btn_comment.hidden = true
        }
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}