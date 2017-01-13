//
//  MenuController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 20/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SnapKit

class MenuController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var User : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    let numberOfRowsAtSection: [Int] = [1, 4, 1, 1]
    let Titlesections : [String] = ["","",""]
    @IBOutlet weak var menuTableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //var cell : UITableViewCell!
            let cell: ProfileMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Menu0", for: indexPath) as! ProfileMenuTableViewCell
            print("\(User)")
            cell.setData(User)
             return cell
        }
        var cell : UITableViewCell!
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu1", for: indexPath)
            }
            else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu2", for: indexPath)
            }
            else if indexPath.row == 2{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu3", for: indexPath)
            }
            else if indexPath.row == 3{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu4", for: indexPath)
            }
        }
        if indexPath.section == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "Menu5", for: indexPath)
        }
        if indexPath.section == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: "Menu8", for: indexPath)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60.0
        }
        else {
            return 45.0
        }
    }
    
    
    @IBAction func Deconnexion(_ sender: AnyObject) {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        
        self.request.request(type: "POST", param: param, add: "auth/sign_out", callback: {
            (isOK, User) -> Void in
            if (isOK) {
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConnectVC") as! ViewController
                self.present(LogInViewController(), animated: true, completion: nil)
            }else{
                // do error handling here
                print("erreur de déconnexion")
            }
        })
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let tbc = self.tabBarController  as! TabBarController
        User = sharedInstance.volunteer["response"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        User = sharedInstance.volunteer["response"]
        
        self.request.request(type: "GET", param: param, add: "volunteers/"+String(describing: User["id"]), callback: {
            (isOK, User) -> Void in
            if (isOK) {
                self.User = User["response"]
                self.menuTableView.reloadData()
            }else{
                // do error handling here
                print("erreur de get user")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        // get a reference to the second view controller
        if(segue.identifier == "GoToProfilVol"){
            let secondViewController = segue.destination as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = String(describing: User["id"])
        }
    }
}

class ProfileMenuTableViewCell : UITableViewCell {
    
    private var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        self.ProfilePicture = UIImageView()
        self.ProfilePicture.layer.cornerRadius = 8.0
        self.ProfilePicture.layer.masksToBounds = true
        self.addSubview(self.ProfilePicture)
        self.ProfilePicture.snp.makeConstraints { (make) in
            make.width.height.equalTo(42.0)
            make.centerY.equalTo(self)
            make.left.equalTo(10.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ user: JSON) {
        self.ProfilePicture.downloadedFrom(link: define.path_picture + String(describing: user["thumb_path"]), contentMode: .scaleToFill)
        self.ProfilePicture.layer.cornerRadius = 8.0
        //self.ProfilePicture.layer.borderColor = UIColor.black.cgColor
        //self.ProfilePicture.layer.borderWidth = 1.0
        
        
        
        self.ProfileName.text = String(describing: user["fullname"])
        self.ProfileName.adjustsFontSizeToFitWidth = true
        self.ProfileName.textAlignment = .center
        self.ProfileName.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.centerY.equalTo(self)
            make.left.equalTo(self.ProfilePicture.snp.right).offset(10.0)
            make.width.equalTo(UIScreen.main.bounds.size.width*0.70)
        }
        
    }
}
