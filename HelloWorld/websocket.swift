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
    let socket : WebSocket = WebSocket(url: NSURL(string: "ws://ws.api.caritathelp.me")! as URL)
   //ws://ws.api.caritathelp.me
    //ws://ws.staging.caritathelp.me


    func firstConnection() {
        socket.connect()
        socket.delegate = self
    }
    
    func isConnected() {
            }

    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        let paramCo = "{\"token\":\"token\", \"token_user\":\"" + String(describing: sharedInstance.volunteer["response"]["token"]) + "\"}"
        print(paramCo)
        socket.write(string: paramCo)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
        
        let tabController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        let tabArray = tabController!.tabBar.items?[3] as UITabBarItem!
        //let alertTabItem = tabArray(3) as! UITabBarItem
        
        if let badgeValue = (tabArray?.badgeValue) {
            let intValue = Int(badgeValue)
            tabArray?.badgeValue = (intValue! + 1).description
            print(intValue)
        } else {
            tabArray?.badgeValue = "1"
        }
    }
    
    
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
