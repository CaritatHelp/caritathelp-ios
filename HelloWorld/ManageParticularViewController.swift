//
//  ManageParticularViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 27/10/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import SCLAlertView

class ManageParticularViewController: UIViewController {
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    @IBOutlet weak var manageTableView: UITableView!
    var from: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = sharedInstance.volunteer["response"]
        //self.manageTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.manageTableView.backgroundColor = UIColor.lightGreenCaritathelp()
        
        configureFooterView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFooterView() {
        let footerView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.manageTableView.frame.width, height: 70.0))
        footerView.backgroundColor = UIColor.lightGreenCaritathelp()
        
        let submit = UIButton()
        submit.setTitle("Mettre à jour", for: UIControlState.normal)
        submit.setTitleColor(UIColor.white, for: UIControlState.normal)
        if self.from == "name" || self.from == "mail" {
        submit.addTarget(self, action: #selector(updatePassord), for: .touchUpInside)
        }else {
            submit.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        }
        footerView.addSubview(submit)
        
        submit.snp.makeConstraints { (make) in
            make.height.equalTo(36.0)
            make.width.equalTo(130.0)
            make.top.equalTo(footerView.snp.top).offset(5.0)
            make.centerX.equalTo(footerView)
        }
        
        self.manageTableView.tableFooterView = footerView
    }
    
    func updatePassord() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        var i = 0
        for cell in self.manageTableView.visibleCells{
            //do someting with the cell here.
            if let customCell = cell as? GeneralCustomCell {
                if customCell.getValue().isEmpty {
                    SCLAlertView().showError("Informations incomplète", subTitle: "Veuillez remplir tous les champs.")
                }
                else{
                    if i == 0 {
                        self.param["password"] = customCell.getValue()
                    }
                    else {
                        self.param["password_confirmation"] = customCell.getValue()
                    }
                }
            }
            i += 1
        }
        
        request.request(type: "PUT", param: self.param,add: "auth/password", callback: {
            (isOK, User)-> Void in
            if(isOK){
                if User["status"] == 400 {
                    SCLAlertView().showError("Erreur", subTitle: String(describing: User["message"]))
                } else {
                    SCLAlertView().showSuccess("Bravo", subTitle: "votre mot de passe à été mis à jour.")
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                SCLAlertView().showError("Erreur", subTitle: "Une erreure est survenue.")
            }
        });

    }
    
    func updateProfile() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        var i = 0
        for cell in self.manageTableView.visibleCells{
            //do someting with the cell here.
            if let customCell = cell as? GeneralCustomCell {
                if customCell.getValue().isEmpty {
                    SCLAlertView().showError("Informations incomplète", subTitle: "Veuillez remplir tous les champs.")
                }
                else{
                    if self.from == "name" {
                        if i == 0 {
                            self.param["firstname"] = customCell.getValue()
                        }
                        else {
                            self.param["lastname"] = customCell.getValue()
                        }
                    }
                    if self.from == "mail" {
                        self.param["email"] = customCell.getValue()
                    }
                }
            }
            i += 1
        }
        
        request.request(type: "PUT", param: self.param,add: "auth", callback: {
            (isOK, User)-> Void in
            if(isOK){
                if User["status"] == 400 {
                    SCLAlertView().showError("Erreur", subTitle: String(describing: User["message"]))
                } else {
                sharedInstance.volunteer = User
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                SCLAlertView().showError("Erreur", subTitle: "Une erreure est survenue.")
            }
        });

    }

}

extension ManageParticularViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40.0
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
            make.left.equalTo(headerSectionView).offset(0.0)
            make.right.equalTo(headerSectionView).offset(0.0)
            make.bottom.equalTo(headerSectionView)
            make.height.equalTo(1.0)
        }
        
        switch self.from! {
        case "name":
            headerSectionLabel.text = "Prénom et nom"
        case "mail":
            headerSectionLabel.text = "Mail"
        case "password":
            headerSectionLabel.text = "Autorisation"
        default:
            return nil
        }
        return headerSectionView
    }
}


extension ManageParticularViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var title = ""
        var placeholder = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "generalCell", for: indexPath as IndexPath) as! GeneralCustomCell
        cell.backgroundColor = UIColor.lightGreenCaritathelp()
        if from == "name" {
            if indexPath.row == 0 {
                title = String(describing: user["firstname"])
                placeholder = "Prénom"
            }
            else {
                title = String(describing: user["lastname"])
                    placeholder = "Nom"
            }
        }
        else if from == "mail" {
            title = String(describing: user["email"])
            placeholder = "Mail"
        }
        else if from == "password" {
            if indexPath.row == 0 {
                placeholder = "Nouveau mot de passe"
            }
            else {
                placeholder = "Confirmation mot de passe"
            }
        }
              cell.setCell(NameLabel: title, Placeholder: placeholder)
            return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.from! {
        case "name":
            return 2
        case "mail":
            return 1
        case "password":
            return 2
        default:
            return 1
        }
    }
}

class GeneralCustomCell : UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getValue() -> String{
        return self.textField.text!
    }
    
    func setCell(NameLabel: String, Placeholder: String){
        if !NameLabel.isEmpty {
            self.textField.text = NameLabel
        }
        else {
            self.textField.text = ""
        }
        self.textField.placeholder = Placeholder
        self.textField.backgroundColor = UIColor.lightGreenCaritathelp().withAlphaComponent(0.5)
    }
}
