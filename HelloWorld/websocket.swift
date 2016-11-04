//
//  websocket.swift
//  Caritathelp
//
//  Created by Jeremy gros on 02/07/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON

class ConnectionWebSocket : WebSocketDelegate {
    
    var i = 0
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
        let tabArrayNotif = tabController!.tabBar.items?[3] as UITabBarItem!
        let tabArrayMsg = tabController!.tabBar.items?[3] as UITabBarItem!
        //let alertTabItem = tabArray(3) as! UITabBarItem
        //let split = text.characters.split(separator: ",")
        var myStringArr = text.components(separatedBy: ",")
        
        var TableData = [String: String]()
        for str in myStringArr {
            //str.replacingOccurrences(of: "{", with: "")
            var split = str.components(separatedBy: ":")
            
            TableData[split[0]] = split[1]
        }
        
        //data = json
        print("------")
        print(TableData)
        print("------")
        if TableData["\"type\""] == "\"message\"}" {
            if let badgeValue = (tabArrayMsg?.badgeValue) {
            let intValue = Int(badgeValue)
            tabArrayMsg?.badgeValue = (intValue! + 1).description
        }
        else {
            if let badgeValue = (tabArrayNotif?.badgeValue) {
                let intValue = Int(badgeValue)
                tabArrayNotif?.badgeValue = (intValue! + 1).description
            } else {
                tabArrayNotif?.badgeValue = "1"
            }
        }
        }
    }
    //{"chatroom_id":17,"sender_id":4,"sender_firstname":"Jeremy","sender_lastname":"Gros","sender_thumb_path":"/uploads/picture/default_m.png","content":"C'est bien nous les meilleurs ! ;)","created_at":"2016-10-13T23:11:26.665+02:00","type":"message"}
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }
    
    func AnalyzeData(notif: JSON){
        var message = ""
        let dateTime = NSDate()
        
        switch notif[""] {
        case "AddFriend":
            message = String(describing: notif["sender_name"]) + " veut vous ajouter en ami."
            case "NewGuest":
            message = String(describing: notif["sender_name"]) + " a rejoint l'évènement : " + String(describing: notif["event_name"])
        case "NewMember":
            message = String(describing: notif["sender_name"]) + " a rejoint l'association : " + String(describing: notif["assoc_name"])
        case "JoinAssoc":
            message = String(describing: notif["sender_name"]) + " veut rejoindre l'association : " + String(describing: notif["assoc_name"])
        case "JoinEvent":
             message = String(describing: notif["sender_name"]) + " veut rejoindre l'évènement : " + String(describing: notif["event_name"])
        case "InviteMember":
             message = String(describing: notif["sender_name"]) + " vous invite à rejoindre l'association : " + String(describing: notif["assoc_name"])
        case "InviteGuest":
            message = String(describing: notif["sender_name"]) + " vous invite à rejoindre l'évènement : " + String(describing: notif["assoc_name"])
        default:
            message = ""
        }
        
        // create a corresponding local notification
        //let notification = UILocalNotification()
        //notification.alertBody = message
        //notification.alertAction = "open"
        //notification.fireDate = dateTime as Date
        //notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        
        //UIApplication.shared.scheduleLocalNotification(notification)
        
    }
    
}

//let ws = ConnectionWebSocket()
