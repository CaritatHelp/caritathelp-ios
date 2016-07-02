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
   
    
    func firstConnection(paramCo: String) {
        socket.connect()
        socket.delegate = self
        socket.writeString(paramCo)
    }
    
    func isConnected() {
            }

    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }
    func websocketDidReceivePong(socket: WebSocket) {
        print("Got pong!")
    }
}

let ws = ConnectionWebSocket()