//
//  HomeController.swift
//  HelloWorld
//
//  Created by Jeremy gros on 16/12/2015.
//  Copyright © 2015 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON


class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user : JSON = []
    
    
    @IBOutlet weak var labeltest: UILabel!
    
    @IBAction func testNotifs(sender: AnyObject) {
        print(NSDate().dateByAddingTimeInterval(60*60*2+5))
        
        var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert
        
        var justInformAction = UIMutableUserNotificationAction()
        justInformAction.identifier = "justInform"
        justInformAction.title = "OK, got it"
        justInformAction.activationMode = UIUserNotificationActivationMode.Foreground
        justInformAction.destructive = false
        justInformAction.authenticationRequired = false
        
        let categoriesForSettings = NSSet(objects: justInformAction)
        
        
        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellHomePage = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as! CustomCellHomePage
        
        //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
        cell.setCell("",DateLabel: "2016-03-22 17:02", imageName: "", content: "")
        cell.layer.cornerRadius = 5
        //cell.layer.borderColor = UIColor.grayColor().CGColor
        //cell.layer.borderWidth = 5
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: cell.frame.size.height - width, width:  cell.frame.size.width, height: cell.frame.size.height)
        
        border.borderWidth = width
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    
    func getData(_user:JSON){
        print("recu la data")
        self.user = _user
        //labeltest.text = String(self.user["response"]["firstname"])
        print("recu la data : \(user)")
    }
    
    @IBAction func goToMenu(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as! MenuController
        //Pass delegate and variable to vc which is HomeController
        vc.User = user
        //vc.teststring = "hello"
        
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let tbc = self.tabBarController  as! TabBarController
        user = tbc.user
        print("entere : \(self.user)")
        
        
        labeltest.text = String(self.user["response"]["firstname"])
        
    }

}
