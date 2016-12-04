//
//  ShelterViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 03/12/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class ShelterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : JSON = []
    var AssocID = ""
    var rights = ""
    var request = RequestModel()
    var param = [String: String]()
    var shelters : JSON = []

    @IBOutlet weak var shelters_list: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ShelterViewController.loadData), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ShelterCustomCell = shelters_list.dequeueReusableCell(withIdentifier: "sheltersCell", for: indexPath as IndexPath) as! ShelterCustomCell
        let name = String(describing: shelters[indexPath.row]["name"])
        cell.setCell(NameLabel: name, shelter: shelters[indexPath.row], rights: rights)
        
        cell.tapped_modify = { [unowned self] (selectedCell, shelter) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateShelterVC") as! CreateShelterViewController
            //Pass delegate and variable to vc which is HomeController
            vc.shelter = shelter
            vc.create = false
            vc.AssocID = self.AssocID

           self.navigationController?.pushViewController(vc, animated: true)
            
        }

        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shelters.count
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shelters_list.tableFooterView = UIView()
        self.shelters_list.addSubview(self.refreshControl)
        user = sharedInstance.volunteer["response"]
        //self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        //        self.param["access-token"] = sharedInstance.header["access-token"]
        //        self.param["client"] = sharedInstance.header["client"]
        //        self.param["uid"] = sharedInstance.header["uid"]

        let val = "associations/" + AssocID + "/shelters"
        request.request(type: "GET", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.shelters = User["response"]
                self.shelters_list.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                
            }
        });

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x:0,y:0,width:216,height:160))
        let x = (subview.frame.width - 180) / 2
        
        let place = UILabel(frame: CGRect(x: x,y:10,width:180,height:30))
        place.text = "places : " + String(describing: shelters[indexPath.row]["free_places"]) + " / " + String(describing: shelters[indexPath.row]["total_places"])
        place.font = UIFont(name: "HelveticaNeue", size: 14)!
        place.adjustsFontSizeToFitWidth = true
        subview.addSubview(place)
        
        let telephone = UILabel(frame: CGRect(x: x,y:40,width:180,height:30))
        telephone.text = "téléphone: " + String(describing: shelters[indexPath.row]["phone"])
        telephone.font = UIFont(name: "HelveticaNeue", size: 14)!
        telephone.adjustsFontSizeToFitWidth = true
        subview.addSubview(telephone)
        
        let mail = UILabel(frame: CGRect(x: x,y:70,width:180,height:30))
        mail.text = "mail: " + String(describing: shelters[indexPath.row]["mail"])
        mail.font = UIFont(name: "HelveticaNeue", size: 14)!
        mail.adjustsFontSizeToFitWidth = true
        subview.addSubview(mail)
        
        let address = UILabel(frame: CGRect(x: x,y:90,width:180,height:60))
        address.text = "adresse : " + String(describing: shelters[indexPath.row]["address"]) + " " + String(describing: shelters[indexPath.row]["zipcode"]) + " " + String(describing: shelters[indexPath.row]["city"])
        address.font = UIFont(name: "HelveticaNeue", size: 14)!
        address.adjustsFontSizeToFitWidth = true
        address.numberOfLines = 3
        subview.addSubview(address)
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        alert.addButton("ok") {
        }
        
        alert.showSuccess("Informations", subTitle: "")
    }
}

class ShelterCustomCell: UITableViewCell {
    
    @IBOutlet weak var TitleNews: UILabel!
    @IBOutlet weak var modifyBtn: UIButton!
    
    var shelter: JSON = []
    var tapped_modify: ((ShelterCustomCell, JSON) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func ModifyShelter(_ sender: Any) {
        self.tapped_modify?(self, shelter)
    }
    
    func setCell(NameLabel: String, shelter: JSON, rights: String){
        self.TitleNews.text = NameLabel
        self.shelter = shelter
        if rights == "owner" {
            self.modifyBtn.isHidden = false
        }
        else {
            self.modifyBtn.isHidden = true
        }
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
    
}

