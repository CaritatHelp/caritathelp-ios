//
//  HomeController.swift
//  HelloWorld
//
//  Created by Jeremy gros on 16/12/2015.
//  Copyright © 2015 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyJSON
import SCLAlertView


class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var actu : JSON = []
    
    
    @IBOutlet weak var list_Actu: UITableView!
    
    @IBOutlet weak var labeltest: UILabel!
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeController.refreshActu), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellHomePage = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as! CustomCellHomePage
        
        //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
        if String(actu[indexPath.row]["volunteer_id"]) != nil {
        cell.setCell(String(actu[indexPath.row]["volunteer_name"]),DateLabel: String(actu[indexPath.row]["updated_at"]), imageName: define.path_picture + String(actu[indexPath.row]["volunteer_thumb_path"]), content: String(actu[indexPath.row]["content"]))
        } else if String(actu[indexPath.row]["assoc_id"]) != nil {
            cell.setCell(String(actu[indexPath.row]["title"]),DateLabel: String(actu[indexPath.row]["updated_at"]), imageName: define.path_picture + String(actu[indexPath.row]["assoc_thumb_path"]), content: String(actu[indexPath.row]["content"]))
        } else {
            cell.setCell(String(actu[indexPath.row]["title"]),DateLabel: String(actu[indexPath.row]["updated_at"]), imageName: define.path_picture + String(actu[indexPath.row]["event_thumb_path"]), content: String(actu[indexPath.row]["content"]))
        }
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
        return actu.count
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
        self.list_Actu.addSubview(self.refreshControl)
        let tbc = self.tabBarController  as! TabBarController
        user = tbc.user
        print("entere : \(self.user)")
        
        
        //labeltest.text = String(self.user["response"]["firstname"])
        refreshActu()
        
            }
    
    func refreshActu() {
        param["token"] = String(user["response"]["token"])
        request.request("GET", param: param, add: "news", callback: {
            (isOK, User)-> Void in
            if(isOK){
                //self.refreshActu()
                self.actu = User["response"]
                self.list_Actu.reloadData()
                self.refreshControl.endRefreshing()
                
            }
            else {
                SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
            }
        });

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "detailNewsfromHome"){
            let indexPath = list_Actu.indexPathForCell(sender as! UITableViewCell)
            let secondViewController = segue.destinationViewController as! CommentActuController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.IDnews = String(actu[indexPath!.row]["id"])
            //secondViewController.user = user
        }
    }

}






