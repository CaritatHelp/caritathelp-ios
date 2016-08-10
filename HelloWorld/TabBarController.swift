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

class TabBarController : UITabBarController {
    var user : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (sharedInstance.nb_notif > 0){
//        self.tabBar.items?[3].badgeValue = String(sharedInstance.nb_notif)
//        }else{
//            self.tabBar.items?[3].badgeValue = ""
//        }
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
