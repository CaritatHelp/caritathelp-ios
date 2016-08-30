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
        if indexPath.row == 0 {
            let cell : CustomCellActu = tableView.dequeueReusableCellWithIdentifier("customcellactu", forIndexPath: indexPath) as! CustomCellActu
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
//        let date = dateFormatter.dateFromString(String(actu[indexPath.row]["updated_at"]))
//        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
//        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
//        let datefinale = dateFormatter.stringFromDate(date!)
//        print("date = " + datefinale)
       
        let datefinale = String(actu[indexPath.section]["updated_at"])
        //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
        if String(actu[indexPath.section]["volunteer_id"]) != nil {
        cell.setCell(String(actu[indexPath.section]["volunteer_name"]),DateLabel: datefinale, imageName: define.path_picture + String(actu[indexPath.section]["volunteer_thumb_path"]), content: String(actu[indexPath.section]["content"]))
        } else if String(actu[indexPath.section]["assoc_id"]) != nil {
            cell.setCell(String(actu[indexPath.section]["title"]),DateLabel: datefinale, imageName: define.path_picture + String(actu[indexPath.section]["assoc_thumb_path"]), content: String(actu[indexPath.section]["content"]))
        } else {
            cell.setCell(String(actu[indexPath.section]["title"]),DateLabel: datefinale, imageName: define.path_picture + String(actu[indexPath.section]["event_thumb_path"]), content: String(actu[indexPath.section]["content"]))
        }


            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("commentcell", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
        //cell.layer.cornerRadius = 5
        //cell.layer.borderColor = UIColor.grayColor().CGColor
        //cell.layer.borderWidth = 5
        
//        let border = CALayer()
//        let width = CGFloat(2.0)
//        border.borderColor = UIColor.darkGrayColor().CGColor
//        border.frame = CGRect(x: 0, y: cell.frame.size.height - width, width:  cell.frame.size.width, height: cell.frame.size.height)
//        
//        border.borderWidth = width
//        cell.layer.addSublayer(border)
//        cell.layer.masksToBounds = true
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return actu.count
        
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 5.0
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 140
//        } else {
//            return UITableViewAutomaticDimension
//        }
//    }
    

    
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
        list_Actu.registerNib(UINib(nibName: "CustomCellActu", bundle: nil), forCellReuseIdentifier: "customcellactu")
        list_Actu.estimatedRowHeight = 159.0
        list_Actu.rowHeight = UITableViewAutomaticDimension
        //list_Actu.rowHeight = 44
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
            secondViewController.IDnews = String(actu[indexPath!.section]["id"])
            //secondViewController.user = user
        }
        if(segue.identifier == "showcommentfromcommenthome"){
            let indexPath = list_Actu.indexPathForCell(sender as! UITableViewCell)
            let secondViewController = segue.destinationViewController as! CommentActuController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.IDnews = String(actu[indexPath!.section]["id"])
            //secondViewController.user = user
        }
    }

}






