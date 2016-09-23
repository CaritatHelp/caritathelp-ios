//
//  TabBarController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 26/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Starscream

class TabBarController : UITabBarController {
    var user : JSON = []
    var nb_notif = 0
    //var mySocket = ConnectionWebSocket()
    
//    let socket : WebSocket = WebSocket(url: NSURL(string: "ws://api.caritathelp.me:8080/")!)
//    
//    func websocketDidConnect(socket: WebSocket) {
//        print("websocket is connected")
//        let paramCo = "{\"token\":\"token\", \"token_user\":\"" + String(sharedInstance.volunteer["response"]["token"]) + "\"}"
//        socket.writeString(paramCo)
//    }
//    
//    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
//        print("websocket is disconnected: \(error?.localizedDescription)")
//    }
//    
//    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
//        print("got some text: \(text)")
//        
//        let notif = JSON(text)
//        //AnalyzeData(notif)
//        nb_notif += 1
//        
//        if nb_notif == 0 {
//            self.tabBar.items?[3].badgeValue = nil
//        }else {
//            self.tabBar.items?[3].badgeValue = String(nb_notif)
//        }
//        
//    }
//    
//    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
//        print("got some data: \(data.length)")
//    }
//    func websocketDidReceivePong(socket: WebSocket) {
//        print("Got pong!")
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mySocket.firstConnection()
//        if (sharedInstance.nb_notif > 0){
//        self.tabBar.items?[3].badgeValue = String(sharedInstance.nb_notif)
//        }else{
//            self.tabBar.items?[3].badgeValue = ""
//         }
        self.tabBar.items?[3].badgeValue = nil
        self.tabBar.tintColor = UIColor(red: 111/255, green: 170/255, blue: 131/255, alpha: 1)
        self.tabBar.barTintColor = UIColor.whiteColor()
        self.tabBar.translucent = false

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let tabBarC = segue.destinationViewController as! TabBarController
        let firstViewController = tabBarC.viewControllers?.first as! HomeController

        firstViewController.user = user
    }
}
