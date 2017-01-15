//
//  ManageProfileViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 27/10/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class ManageProfileViewController: UIViewController {

    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()

    @IBOutlet weak var manageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = sharedInstance.volunteer["response"]
        self.manageTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.manageTableView.backgroundColor = UIColor.lightGreenCaritathelp()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = sharedInstance.volunteer["response"]
        self.manageTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateAutorisation(_ sender: AnyObject) {
        var on = ""
        if sender.isOn == true {
            on = "true"
        }
        else {
            on = "false"
        }
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        if sender.tag == 0 {
            self.param["allow_notifications"] = on
        }
        else {
            self.param["allowgps"] = on
        }
        request.request(type: "PUT", param: self.param,add: "auth", callback: {
            (isOK, User)-> Void in
            if(isOK){
                if User["status"] == 400 {
                    SCLAlertView().showError("Erreur", subTitle: String(describing: User["message"]))
                }
                self.user = User["response"]
                self.manageTableView.reloadData()
            }
            else {
                SCLAlertView().showError("Erreur", subTitle: "Une erreure est survenue.")
            }
        });

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        if(segue.identifier == "modifyname"){
            let secondViewController = segue.destination as! ManageParticularViewController
            
            // set a variable in the second view controller with the String to pass

            secondViewController.from = "name"
        }
        if(segue.identifier == "modifymail"){
            let secondViewController = segue.destination as! ManageParticularViewController
            
            // set a variable in the second view controller with the String to pass
            
            secondViewController.from = "mail"
        }
        if(segue.identifier == "modifypassword"){
            let secondViewController = segue.destination as! ManageParticularViewController
            
            // set a variable in the second view controller with the String to pass
            
            secondViewController.from = "password"
        }

    }


}

extension ManageProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        }
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionView = UIView(frame: CGRect(x:0, y: 0, width: tableView.bounds.size.width, height: 30))
        //headerSectionView.backgroundColor = UIColor.white
        
        let headerSectionLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 250, height: 27))
        headerSectionLabel.textAlignment = .left
        headerSectionLabel.font = UIFont.profileSectionFont()
        headerSectionLabel.textColor = UIColor.black
        
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        
        headerSectionView.addSubview(headerSectionLabel)
        headerSectionView.addSubview(separator)
        
        separator.snp.makeConstraints { (make) in
            make.left.equalTo(headerSectionView).offset(13.0)
            make.right.equalTo(headerSectionView).offset(0.0)
            make.bottom.equalTo(headerSectionView)
            make.height.equalTo(1.0)
        }
        
        switch section {
        case 0:
           headerSectionLabel.text = "Prénom et nom"
        case 1:
            headerSectionLabel.text = "Mail"
        case 2:
            headerSectionLabel.text = "Autorisation"
        case 3:
            headerSectionLabel.text = "Mot de passe"
        default:
            return nil
        }
        return headerSectionView
    }
}


extension ManageProfileViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "introductionCell", for: indexPath as IndexPath) as! IntroductionCustomCell
            cell.backgroundColor = UIColor.lightGreenCaritathelp()
            cell.setCell(image: define.path_picture + String(describing: user["thumb_path"]), texte: String(describing: user["fullname"]))
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "autorisationCell", for: indexPath as IndexPath) as! AutorisationCustomCell
            cell.backgroundColor = UIColor.lightGreenCaritathelp()
            var title = ""
            title = "Géolocalisations"
            cell.setCell(NameLabel: String(describing: user["allowgps"]), texte: title)
            return cell
        }
        else {
            
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "generalCell", for: indexPath as IndexPath) as! General2CustomCell
                cell.backgroundColor = UIColor.lightGreenCaritathelp()
                cell.textLabel?.text = String(describing: user["email"])
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "general2Cell", for: indexPath as IndexPath) as! General2CustomCell
                cell.backgroundColor = UIColor.lightGreenCaritathelp()
                cell.textLabel?.text = "Modifier votre mot de passe"
                return cell
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 1
//        case 2:
//            return 1
//        case 3:
//            return 1
//        default:
//            return 1
//        }
        return 1
    }
}

class General2CustomCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class AutorisationCustomCell : UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    func getValue() -> Bool {
        return self.switcher.isOn
    }
    
    func setCell(NameLabel: String, texte: String){
        if NameLabel == "true" {
            self.switcher.isOn = true
        }
        else {
            self.switcher.isOn = false
        }
        self.switcher.backgroundColor = UIColor.red
        self.switcher.layer.cornerRadius = 16
        self.label.text = texte
        if texte == "Notifications" {
            self.switcher.tag = 0
        }
        else {
            self.switcher.tag = 1
        }
    }
    
}

class IntroductionCustomCell : UITableViewCell {
    

    @IBOutlet weak var pictureProfile: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    func setCell(image: String, texte: String){
        self.label.text = texte
        self.pictureProfile.downloadedFrom(link: image, contentMode: .scaleToFill)
        self.pictureProfile.layer.cornerRadius = self.pictureProfile.frame.size.width / 2;
        self.pictureProfile.layer.borderWidth = 1.0
        self.pictureProfile.layer.borderColor = UIColor.darkGray.cgColor;
        self.pictureProfile.layer.masksToBounds = true
        self.pictureProfile.clipsToBounds = true
    }
    
}
