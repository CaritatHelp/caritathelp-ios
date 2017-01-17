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
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = false

    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarC = segue.destination as! TabBarController
        let firstViewController = tabBarC.viewControllers?.first as! HomeController

        firstViewController.user = user
    }
}
