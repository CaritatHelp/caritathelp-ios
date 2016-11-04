//
//  ListchatroomController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 23/09/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView
import SlackTextViewController

class ListchatroomController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var list_room : JSON = []
    var message_list : JSON = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListchatroomController.refresh_chatroom), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    @IBOutlet weak var tableview_room: UITableView!

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableview_room.dequeueReusableCell(withIdentifier: "roomcell", for: indexPath as IndexPath) as! CustomRoomCell
        var title = String(describing: list_room[indexPath.row]["name"])
        
        if String(describing: list_room[indexPath.row]["name"]) == "" {
            title = String(describing: list_room[indexPath.row]["volunteers"][0])
        }
        
            cell.setCell(NameLabel: title, DetailLabel: String(describing: list_room[indexPath.row]["name"]), imageName: define.path_picture + String(describing: list_room[indexPath.row]["thumb_path"]))
            return cell
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_room.count
    }

    override func viewWillAppear(_ animated: Bool) {
        let tabController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        let tabArray = tabController!.tabBar.items?[2] as UITabBarItem!
        tabArray?.badgeValue = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview_room.tableFooterView = UIView()
        self.tableview_room.addSubview(self.refreshControl)
        refresh_chatroom()
        
    }
    
    func refresh_chatroom() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "chatrooms"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.list_room = User["response"]
                self.refreshControl.endRefreshing()
                self.tableview_room.reloadData()
                //self.refreshActu()
            }
            else {
                
            }
        });

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        if(segue.identifier == "showchatroom"){
            
            let indexPath = tableview_room.indexPath(for: sender as! UITableViewCell)
                                let secondViewController = segue.destination as! chatroomController
                    
                    // set a variable in the second view controller with the String to pass
                    print("ID = " + String(describing: self.list_room[indexPath!.section]["id"]))
                    secondViewController.chatroomID = String(describing: self.list_room[indexPath!.row]["id"])
            secondViewController.chatroomTitle = String(describing: self.list_room[indexPath!.row]["name"])
            
                    }
        if(segue.identifier == "newchatroom"){
            
            let secondViewController = segue.destination as! NewChatroomController
           
            secondViewController.from = "new"
        }
    }
    
}

class CustomRoomCell: UITableViewCell {
    
    @IBOutlet weak var ImageProfilFriends: UIImageView!
    @IBOutlet weak var NameRoom: UILabel!
    @IBOutlet weak var LastMessage: UILabel!
    
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
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String){
        //self.TitleNews.text = NameLabel
        self.LastMessage.text = DetailLabel
        self.ImageProfilFriends.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.ImageProfilFriends.layer.cornerRadius = self.ImageProfilFriends.frame.size.width / 2
        self.ImageProfilFriends.layer.borderColor = UIColor.darkGray.cgColor;
        self.ImageProfilFriends.layer.masksToBounds = true
        self.ImageProfilFriends.clipsToBounds = true
        self.NameRoom.text = NameLabel
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
}
