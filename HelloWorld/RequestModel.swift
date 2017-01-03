    //
//  RequestModel.swift
//  Caritathelp
//
//  Created by Jeremy gros on 14/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration

class RequestModel {
    
    var status = ""
    let server = "http://staging.caritathelp.me/" //http://api.caritathelp.me/
    
    func request(type:String,param:[String:Any], add:String, callback: ((_ isOk: Bool, _ User : JSON)->Void)?){
        
        guard Reachability.isConnectedToNetwork() else {
            let jsonFail: JSON = ["connection":"false"]
            callback?(false, jsonFail)
            return
        }
        
        var res : AnyObject = "" as AnyObject
        if(type == "POST"){
            Alamofire.request(server + add, method: .post, parameters: param)
            .responseJSON() { response in
                print("Response JSON: \(response.result.value)")
                
                if add == "auth/sign_in" {
                    print("HEADER\(response.response!.allHeaderFields["client"] as AnyObject)")
                    sharedInstance.header["client"] = String(describing: response.response!.allHeaderFields["client"] as AnyObject)
                    sharedInstance.header["access-token"] = String(describing: response.response!.allHeaderFields["access-token"] as AnyObject)
                    sharedInstance.header["uid"] = String(describing: response.response!.allHeaderFields["uid"] as AnyObject)
                    
                }
                var json : JSON = []
                if let res = response.result.value {
                     json = JSON(res)
                }
                switch response.result {
                case .success:
                    callback?(true, json)
                case .failure( _):
                    callback?(false, json) }
            }
        }
        else if(type == "GET"){
            Alamofire.request(server+add, method: .get, parameters: param)
                .responseJSON { response in
                    //                    guard response.result.isSuccess else {
                    //                        print("Error while fetching remote rooms: \(response.result.error)")
                    //                        return
                    //                    }
                    print("Response JSON: \(response.result.value)")
                    res = response.result.value! as AnyObject
                    let json = JSON(res)
                    //self.status = String(res["status"])
                    switch response.result {
                    case .success:
                        callback?(true, json)
                     case .failure(let error):
                        print(error)
                        callback?(false, json) }
                    
            }
        }
        else if(type == "PUT"){
            
            Alamofire.request(server + add, method: .put, parameters: param)
                .responseJSON { response in
                    print("Response JSON: \(response.result.value)")
                    res = response.result.value! as AnyObject
                    let json = JSON(res)
                    //print(json["response"]["lastname"])
                    switch response.result {
                    case .success:
                        callback?(true, json)
                    case .failure(let error):
                        print(error)
                        callback?(false, json) }
                    
            }
        }
        else if(type == "DELETE"){
            
            Alamofire.request(server+add, method: .delete, parameters: param)
                .responseJSON { response in
                    print("Response JSON: \(response.result.value)")
                    res = response.result.value! as AnyObject
                    let json = JSON(res)
                    switch response.result {
                    case .success:
                        callback?(true, json)
                    case .failure(let error):
                        print(error)
                        callback?(false, json) }
                    
            }
        }

    }
    
    func requestDeco(callback: ((_ isOk: Bool)->Void)?){
        
        //var res : AnyObject = "" as AnyObject
        Alamofire.request(server+"auth/sign_out", method: .post).responseJSON { response in
            print("Response JSON: \(response.result.value)")
            //res = response.result.value! as AnyObject
            switch response.result {
            case .success:
                callback?(true)
            case .failure(let error):
                print(error)
                callback?(false) }
        }
    }
}
    
    public class Reachability {
        
        class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
            
        }
    }
