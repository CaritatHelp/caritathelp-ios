//
//  chatroomController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 12/10/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SlackTextViewController
import SwiftyJSON
import SnapKit
import Starscream


class chatroomController : SLKTextViewController, WebSocketDelegate {
    
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var list_room : JSON = []
    var chatroomID: String?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListchatroomController.refresh_chatroom), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var tableview_room: UITableView!
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath as IndexPath) as! CustomMessageCell
        cell.setCell(NameLabel: String(describing: list_room[indexPath.row]["fullname"]), DetailLabel: String(describing: list_room[indexPath.row]["content"]), imageName: define.path_picture + String(describing: list_room[indexPath.row]["thumb_path"]), id: String(describing: list_room[indexPath.row]["volunteer_id"]))
        cell.transform = (self.tableView?.transform)!
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NB MESSAGE = \(list_room.count)")
        return list_room.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstConnection()
        
        self.isInverted = true
        self.tableView?.tableFooterView = UIView()
        self.tableView?.addSubview(self.refreshControl)
        self.tableView?.register(CustomMessageCell.self, forCellReuseIdentifier: "messageCell")
        self.tableView?.allowsSelection = false
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 70
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.rightButton.tintColor = UIColor.greenCaritathelp()
        
        self.tableView?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(40.0)
        }
        
        self.refresh_chatroom()
        
    }
    
    func loadNewMessage(json: JSON) {
        //var msg2 = msg.replacingOccurrences(of: "\"", with: "")
        //var name2 = name.replacingOccurrences(of: "\"", with: "")
        //print("TOTO : " + msg2)
        var TableData:Array< JSON > = Array < JSON >()
        let total = self.list_room.count
        var i = 0
        while i < total{
            TableData.append(self.list_room[i])
            i += 1
        }
        TableData.insert(json, at: 0)
        self.list_room = JSON(TableData)
        self.tableView?.reloadData()

    }
    
    func refresh_chatroom() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        print("CHATROOM ID : \(self.chatroomID)")
        let val = "chatrooms/" + self.chatroomID!
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.list_room = User["response"]
                var TableData:Array< JSON > = Array < JSON >()
                var i = self.list_room.count - 1
                var count = 0
                print(i)
                while i >= 0 {
                    //let rowToSelect: IndexPath = IndexPath(forRow: i, inSection: 0) //NSIndexPath(forRow: i, inSection: 0)
                    
                        TableData.append(self.list_room[i])
                        count += 1
                    i -= 1
                }
                print(count)
                self.list_room = JSON(TableData)
                self.tableView?.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                
            }
        });
    }
    
    
   override func didPressRightButton(_ sender: Any?) {
    let message = self.textView.text
        super.didPressRightButton(sender) // this important. calling the super.didPressRightButton will clear the method. We cannot use rx_tap due to inheritance
    self.param["access-token"] = sharedInstance.header["access-token"]
    self.param["client"] = sharedInstance.header["client"]
    self.param["uid"] = sharedInstance.header["uid"]
    self.param["content"] = message
    
    let val = "chatrooms/" + self.chatroomID! + "/new_message"
    
    request.request(type: "PUT", param: param,add: val, callback: {
        (isOK, User)-> Void in
        if(isOK){
            //var TableData:Array< JSON > = Array < JSON >()
            //let total = self.list_room.count
            //var i = 0
            //while i < total{
            //       TableData.append(self.list_room[i])
            //    i += 1
            //}
            //TableData.insert(User["response"], at: 0)
            //self.list_room = JSON(TableData)
            //self.tableView?.reloadData()
        }
        else {
            
        }
    });

    }
    
    // WEBSOCKET 
    let socket : WebSocket = WebSocket(url: NSURL(string: "ws://ws.staging.caritathelp.me")! as URL)
    //ws://ws.api.caritathelp.me
    //ws://ws.staging.caritathelp.me
    var data : JSON?
    
    func firstConnection() {
        socket.connect()
        socket.delegate = self
    }
    
    func isConnected() {
    }
    
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        let paramCo = "{\"token\":\"token\", \"user_uid\":\"" + String(describing: sharedInstance.header["uid"]!) + "\"}"
        print(paramCo)
        socket.write(string: paramCo)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
        firstConnection()
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
        
        let tabController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        let tabArray = tabController!.tabBar.items?[3] as UITabBarItem!
        //let alertTabItem = tabArray(3) as! UITabBarItem
        //let split = text.characters.split(separator: ",")
        var myStringArr = text.components(separatedBy: ",")
        
        var TableData = [String: String]()
        for str in myStringArr {
            //str.replacingOccurrences(of: "{", with: "")
            var split = str.components(separatedBy: ":")
            
            TableData[split[0].replacingOccurrences(of: "\"", with: "")] = split[1].replacingOccurrences(of: "\"", with: "")
        }
        
        //data = json
        let json = JSON(TableData)
        print("********")
        print(json)
        print("------")
        print(TableData)
        print("------")
        if json["type"] == "message}" {
            
            self.loadNewMessage(json: json)
        }
        else {
            if let badgeValue = (tabArray?.badgeValue) {
                let intValue = Int(badgeValue)
                tabArray?.badgeValue = (intValue! + 1).description
                print(intValue)
            } else {
                tabArray?.badgeValue = "1"
            }
        }
    }
    //{"chatroom_id":17,"sender_id":4,"sender_firstname":"Jeremy","sender_lastname":"Gros","sender_thumb_path":"/uploads/picture/default_m.png","content":"C'est bien nous les meilleurs ! ;)","created_at":"2016-10-13T23:11:26.665+02:00","type":"message"}
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }

    
}

class CustomMessageCell: UITableViewCell {
    
    var bulle: UIView!
    var mybulle: UIView!
    var name: UILabel!
    var content: UILabel!
    var myname: UILabel!
    var mycontent: UILabel!
    
    private var previewImageViewBackground: UIView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 8.0
        view.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.75
        view.layer.shadowRadius = 8.0
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.bulle = UIView(frame: CGRect(x:0.0,y:0.0,width:250.0,height: 70.0))
        self.bulle.backgroundColor = UIColor.grayCaritathelp()
        self.bulle.layer.cornerRadius = 10
        
        self.mybulle = UIView(frame: CGRect(x:0.0,y:0.0,width:250.0,height: 70.0))
        self.mybulle.backgroundColor = UIColor.greenCaritathelp()
        self.mybulle.layer.cornerRadius = 10
        
        self.name = UILabel()
        self.name.font = UIFont.init(name: "Helvetica Neue", size: 11.0)
        self.name.textColor = UIColor.black
        
        self.content = UILabel()
        self.content.font = UIFont.init(name: "Helvetica Neue", size: 14.0)
        self.content.textColor = UIColor.black
        self.content.numberOfLines = 0

        self.myname = UILabel()
        self.myname.font = UIFont.init(name: "Helvetica Neue", size: 11.0)
        self.myname.textColor = UIColor.black
        
        self.mycontent = UILabel()
        self.mycontent.font = UIFont.init(name: "Helvetica Neue", size: 14.0)
        self.mycontent.textColor = UIColor.black
        self.mycontent.numberOfLines = 0
        
        self.bulle.addSubview(self.name)
        self.bulle.addSubview(self.content)
        
        //self.addSubview(self.previewImageViewBackground)
        
        self.mybulle.addSubview(self.myname)
        self.mybulle.addSubview(self.mycontent)
        
        self.addSubview(self.bulle)
        self.addSubview(self.mybulle)
        
        
        
        
        self.bulle.snp.makeConstraints { (make) -> Void in
            //make.height.equalTo(70.0)
            make.width.equalTo(200.0)
            make.left.equalTo(self).offset(10.0)
            make.top.equalTo(self).offset(5.0)
           make.bottom.equalTo(self.snp.bottom).offset(-5.0)
        }
        
        //self.previewImageViewBackground.snp.makeConstraints { (make) in
        //    make.width.equalTo(203.0)
        //    make.left.equalTo(self).offset(19.0)
        //    make.bottom.equalTo(self).offset(9.0)
        //}

        
        self.name.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.bulle.snp.top).offset(4.0)
            make.left.equalTo(self.bulle.snp.left).offset(5.0)
            make.height.equalTo(12.0)
            make.width.equalTo(180.0)
        }
        self.content.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.name.snp.bottom).offset(2.0)
            make.left.equalTo(self.bulle.snp.left).offset(5.0)
            make.width.equalTo(190.0)
            make.bottom.equalTo(self.bulle.snp.bottom).offset(-5.0)
        }
        
        self.myname.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.mybulle.snp.top).offset(2.0)
            make.left.equalTo(self.mybulle.snp.left).offset(5.0)
            make.height.equalTo(12.0)
            make.width.equalTo(180.0)
        }
        self.mycontent.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.myname.snp.bottom).offset(5.0)
            make.left.equalTo(self.mybulle.snp.left).offset(5.0)
            make.width.equalTo(190.0)
            make.bottom.equalTo(self.mybulle.snp.bottom).offset(-5.0)
        }
        
        self.mybulle.snp.remakeConstraints { (make) -> Void in
            //make.height.equalTo(70.0)
            make.width.equalTo(200.0)
            make.right.equalTo(self).offset(-10.0)
            make.top.equalTo(self).offset(5.0)
            make.bottom.equalTo(self.snp.bottom).offset(-5.0)
        }

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
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String, id: String){
        
        
       if id == String(describing: sharedInstance.volunteer["response"]["id"]) {
        self.myname.text = NameLabel
        self.mycontent.text = DetailLabel
        self.bulle.isHidden = true
        self.mybulle.isHidden = false
        }else {
        self.name.text = NameLabel
        self.content.text = DetailLabel
            self.bulle.isHidden = false
            self.mybulle.isHidden = true
        }
        //self.TitleNews.text = NameLabel
        //self.LastMessage.text = DetailLabel
        //self.ImageProfilFriends.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        //self.ImageProfilFriends.layer.cornerRadius = self.ImageProfilFriends.frame.size.width / 2
        //self.ImageProfilFriends.layer.borderColor = UIColor.darkGray.cgColor;
        //self.ImageProfilFriends.layer.masksToBounds = true
        //self.ImageProfilFriends.clipsToBounds = true
        //self.NameRoom.text = NameLabel
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
}
