//
//  AnswerEmergencyViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 13/01/2017.
//  Copyright © 2017 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class AnswerEmergencyViewController: UIViewController {
    
    fileprivate var answerTableView: UITableView?
    fileprivate var user: JSON = []
    fileprivate var answers: JSON = []
    fileprivate var param = [String: String]()
    fileprivate var request = RequestModel()
    var eventID = ""
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AnswerEmergencyViewController.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.answerTableView = UITableView()
        self.answerTableView?.register(AnswerEmergencyTableViewCell.self, forCellReuseIdentifier: AnswerEmergencyTableViewCell.identifier)
        self.answerTableView?.delegate = self
        self.answerTableView?.dataSource = self
        self.answerTableView?.backgroundColor = UIColor.white
        self.answerTableView?.addSubview(self.refreshControl)
        self.answerTableView?.tableFooterView = UIView()
        self.view.addSubview(self.answerTableView!)
        
        self.answerTableView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        print("HERE ANSWER!")
        self.refresh()
    }
    
    func refresh() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "events/" + self.eventID + "/volunteers_from_emergency"
        request.request(type: "GET", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                if User["status"] == 200 {
                    print("\(User)")
                    self.answers = User["response"]
                    self.answerTableView?.reloadData()
                    self.refreshControl.endRefreshing()
                }
                else {
                    SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                }
            }
            else {
                
            }
        });
    }
}

extension AnswerEmergencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerEmergencyTableViewCell.identifier, for: indexPath as IndexPath) as! AnswerEmergencyTableViewCell
        let name = String(describing: answers[indexPath.row]["firstname"]) + " " + String(describing: answers[indexPath.row]["lastname"])
        cell.setCell(name: name, pathImage: define.path_picture + String(describing: answers[indexPath.row]["thumb_path"]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answers.count
    }
}

extension AnswerEmergencyViewController: UITableViewDelegate {
    
}

class AnswerEmergencyTableViewCell: UITableViewCell {
    static let identifier = "AnswerEmergencyTableViewCellIdentifier"
    
    private var profileImage: UIImageView?
    private var nameLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView() {
        
        self.selectionStyle = .none
        
        self.profileImage = UIImageView()
        self.profileImage?.layer.cornerRadius = 15.0
        self.profileImage?.layer.masksToBounds = true
        self.addSubview(self.profileImage!)
        self.profileImage?.snp.makeConstraints({ (make) in
            make.height.width.equalTo(40.0)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10.0)
        })
        
        self.nameLabel = UILabel()
        self.nameLabel?.adjustsFontSizeToFitWidth = true
        self.nameLabel?.textColor = UIColor.black
        self.addSubview(self.nameLabel!)
        self.nameLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(30.0)
            make.width.equalTo(200.0)
            make.centerY.equalTo(self)
            make.left.equalTo(self.profileImage!.snp.right).offset(10.0)
        })
    }
    
    func setCell(name: String, pathImage: String) {
        self.nameLabel?.text = name
        self.profileImage?.downloadedFrom(link: pathImage, contentMode: .scaleToFill)
    }
}
