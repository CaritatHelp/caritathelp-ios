//
//  ProfilVolunteer.swift
//  Caritathelp
//
//  Created by Jeremy gros on 08/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView


class ProfilVolunteer: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate {
    
    var user : JSON = []
    var volunteer : JSON = []
    var actu : JSON = []
    var idvolunteer = ""
    var param = [String: String]()
    var request = RequestModel()
    var main_picture = ""
    
    @IBOutlet weak var profil_list: UITableView!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProfilVolunteer.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cellB : UITableViewCell!
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell : CustomCellProfilVolunteer = profil_list.dequeueReusableCell(withIdentifier: "CellProfilVolunteer", for: indexPath) as! CustomCellProfilVolunteer
                
                cell.showgallery = { [unowned self] (selectedCell) -> Void in
                    let appearance = SCLAlertView.SCLAppearance(
                        showCircularIcon: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("logo") {
                        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "imageViewController")
                        
                        self.navigationController!.pushViewController(VC1, animated: true)
                        
                    }
                    alertView.addButton("gallerie") {//galleryViewController
                        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "galleryViewController") as! GalleryAssoViewController
                        VC1.volunteerID = self.idvolunteer
                        self.navigationController!.pushViewController(VC1, animated: true)
                    }
                    alertView.showSuccess("Photos", subTitle: "Que souhaitez-vous regarder ?")
                    
                }

                
                cell.setCell(NameLabel: String(describing: volunteer["firstname"]) + " " + String(describing: volunteer["lastname"]), DetailLabel: String(describing: volunteer["friendship"]), imageName: define.path_picture + String(describing: volunteer["thumb_path"]), User: volunteer)
                
                
                
                let gradientBackgroundColors = [UIColor(red: 125.0/255, green: 191.0/255, blue: 149.0/255, alpha: 1.0).cgColor, UIColor.white.cgColor]
                let gradientLocations = [0.0,1.0]
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = gradientBackgroundColors
                gradientLayer.locations = gradientLocations as [NSNumber]?
                
                gradientLayer.frame = cell.bounds
                let backgroundView = UIView(frame: cell.bounds)
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
                cell.backgroundView = backgroundView
                
                return cell
            }
            else {
                let cell1 = profil_list.dequeueReusableCell(withIdentifier: "MenuProfil", for: indexPath)
                return cell1
            }
        }
        else {
            
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
//            let date = dateFormatter.dateFromString(String(actu[indexPath.row - 2]["updated_at"]))
//            dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
//            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
//            let datefinale = dateFormatter.stringFromDate(date!)
            if indexPath.row == 0 {
            let datefinale = String(describing: actu[indexPath.section - 1]["updated_at"])
            
            let cell1 : CustomCellActu = profil_list.dequeueReusableCell(withIdentifier: "customcellactu", for: indexPath) as! CustomCellActu
                
                cell1.tapped_modify = { [unowned self] (selectedCell, Newcontent) -> Void in
                    let path = tableView.indexPathForRow(at: selectedCell.center)!

                    self.param["token"] = String(describing: self.user["token"])
                    self.param["content"] = Newcontent
                    self.request.request(type: "PUT", param: self.param, add: "news/" + String(describing: self.actu[path.section - 1]["id"]), callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            self.refreshActu()
                        }
                        else {
                            SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                        }
                    });
                    
                }
                
                cell1.tapped_delete = { [unowned self] (selectedCell, Newcontent) -> Void in
                    let path = tableView.indexPathForRow(at: selectedCell.center)!

                    self.param["token"] = String(describing: self.user["token"])
                    self.request.request(type: "DELETE", param: self.param, add: "news/" + String(describing: self.actu[path.section - 1]["id"]) , callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            //self.refreshActu()
                            self.refreshActu()
                            
                        }
                        else {
                            SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                        }
                    });
                    
                }
                
                var title = ""
                if actu[indexPath.section - 1]["group_name"] == user["fullname"] {
                    title = String(describing: actu[indexPath.section - 1]["volunteer_name"]) + " a publié sur son mur"
                } else {
                    title = String(describing: actu[indexPath.section - 1]["volunteer_name"]) + " a publié sur le mur de " + String(describing: actu[indexPath.section - 1]["group_name"])
                }
                var from = ""
                if actu[indexPath.section - 1]["volunteer_id"] == user["id"] {
                    from = "true"
                }
                else {
                    from = "false"
                }

                cell1.setCell(NameLabel: title, DateLabel:  datefinale, imageName: define.path_picture + String(describing: actu[indexPath.section - 1]["volunteer_thumb_path"]), content: String(describing: actu[indexPath.section - 1]["content"]), from: from)
            return cell1
            } else {
                let cell1 = profil_list.dequeueReusableCell(withIdentifier: "commentactuprofil", for: indexPath) as UITableViewCell
                return cell1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return actu.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return 2
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else if indexPath.row == 1 {
            return 45
        }else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profil_list.tableFooterView = UIView()
        self.profil_list.addSubview(self.refreshControl)
        user = sharedInstance.volunteer["response"]
        profil_list.register(UINib(nibName: "CustomCellActu", bundle: nil), forCellReuseIdentifier: "customcellactu")
        profil_list.estimatedRowHeight = 159.0
        profil_list.rowHeight = UITableViewAutomaticDimension
        print("userID = \(self.user["id"]) + idvolunteer = "+self.idvolunteer)
        if String(describing: self.user["id"]) != self.idvolunteer {
            self.publishButton.isEnabled = false
            self.publishButton.tintColor = UIColor.clear
        }
        
        
        self.refresh()
    }
    
    func refresh(){
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        let val = "volunteers/" + idvolunteer
        self.request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.volunteer = User["response"]
                self.main_picture = define.path_picture + String(describing: User["response"]["thumb_path"])
                self.profil_list.reloadData()
                self.refreshActu()
            }
            else {
                
            }
        });

    }
    
    func refreshActu() {
        let val2 = "volunteers/" + self.idvolunteer + "/news"
        self.request.request(type: "GET", param: self.param,add: val2, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.actu = User["response"]
                self.profil_list.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                
            }
        });

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // get a reference to the second view controller
        if(segue.identifier == "friendoffriend"){
            
            let secondViewController = segue.destination as! MyFriendsController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idfriend = idvolunteer
            secondViewController.fromProfil = true
        }
        if(segue.identifier == "AssoVolunteer"){
            
            let secondViewController = segue.destination as! VolunteerAsso
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = idvolunteer
        }
        if(segue.identifier == "fromprofiltoevents"){
            
            let secondViewController = segue.destination as! VolunteerEventsController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = idvolunteer
        }//fromprofiltoevents
        if(segue.identifier == "fromprofilvolunteer"){
            
            let secondViewController = segue.destination as! ManagePhotoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.from = "1"
            secondViewController.state = "true"
        }
        if(segue.identifier == "gotopostfromprofil"){
            
            let secondViewController = segue.destination as! PostStatutAssoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.from = "profil"
            secondViewController.name = String(describing: self.volunteer["fullname"])
        }
        if(segue.identifier == "gotocommentfromprofil"){
            let indexPath = profil_list.indexPath(for: sender as! UITableViewCell)
            let secondViewController = segue.destination as! CommentActuController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.IDnews = String(describing: actu[indexPath!.section - 1]["id"])
        }
        
        
    }

    
    

}


class CustomCellProfilActu: UITableViewCell {
    
    @IBOutlet weak var PictureActu: UIImageView!
    
    @IBOutlet weak var NameActu: UILabel!
    @IBOutlet weak var DateActu: UILabel!
    
    @IBOutlet weak var contentActu: UITextView!
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
    
    func setCell(NameLabel: String, imageName: String, Date: String, Content: String){
        self.NameActu.text = NameLabel
        self.PictureActu.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.PictureActu.layer.cornerRadius = 10
        self.PictureActu.layer.borderColor = UIColor.darkGray.cgColor;
        self.PictureActu.layer.masksToBounds = true
        self.PictureActu.clipsToBounds = true
        self.DateActu.text = Date
        self.contentActu.text = Content
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}

