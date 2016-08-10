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

class ConnectionWebSocket : WebSocketDelegate, WebSocketPongDelegate {
    
    let socket : WebSocket = WebSocket(url: NSURL(string: "ws://api.caritathelp.me:8080/")!)
   
    
    func firstConnection() {
        socket.connect()
        socket.delegate = self
    }
    
    func isConnected() {
            }

    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        let paramCo = "{\"token\":\"token\", \"token_user\":\"" + String(sharedInstance.volunteer["response"]["token"]) + "\"}"
        socket.writeString(paramCo)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
        
        let notif = JSON(text)
        AnalyzeData(notif)
        sharedInstance.nb_notif += 1
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }
    func websocketDidReceivePong(socket: WebSocket) {
        print("Got pong!")
    }
    
    func AnalyzeData(notif: JSON){
        var message = ""
        let dateTime = NSDate()
        
        switch notif[""] {
        case "AddFriend":
            message = String(notif["sender_name"]) + " veut vous ajouter en ami."
            case "NewGuest":
            message = String(notif["sender_name"]) + " a rejoint l'évènement : " + String(notif["event_name"])
        case "NewMember":
            message = String(notif["sender_name"]) + " a rejoint l'association : " + String(notif["assoc_name"])
        case "JoinAssoc":
            message = String(notif["sender_name"]) + " veut rejoindre l'association : " + String(notif["assoc_name"])
        case "JoinEvent":
             message = String(notif["sender_name"]) + " veut rejoindre l'évènement : " + String(notif["event_name"])
        case "InviteMember":
             message = String(notif["sender_name"]) + " vous invite à rejoindre l'association : " + String(notif["assoc_name"])
        case "InviteGuest":
            message = String(notif["sender_name"]) + " vous invite à rejoindre l'évènement : " + String(notif["assoc_name"])
        default:
            message = ""
        }
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.alertAction = "open"
        notification.fireDate = dateTime
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
}

let ws = ConnectionWebSocket()