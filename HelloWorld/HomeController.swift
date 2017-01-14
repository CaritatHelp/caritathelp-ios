//
//  HomeController.swift
//  HelloWorld
//
//  Created by Jeremy gros on 16/12/2015.
//  Copyright © 2015 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView


class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var actu : JSON = []
    var mySocket = ConnectionWebSocket()
    
    
    @IBOutlet weak var list_Actu: UITableView!
    
    @IBOutlet weak var labeltest: UILabel!
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeController.refreshActu), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell : CustomCellActu = tableView.dequeueReusableCell(withIdentifier: "customcellactu", for: indexPath) as! CustomCellActu
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
//        let date = dateFormatter.dateFromString(String(actu[indexPath.row]["updated_at"]))
//        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
//        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
//        let datefinale = dateFormatter.stringFromDate(date!)
//        print("date = " + datefinale)
            
            cell.tapped_modify = { [unowned self] (selectedCell, Newcontent) -> Void in
                let path = tableView.indexPathForRow(at: selectedCell.center)!
                let selectedItem = self.actu[path.section]["content"]
                
               print("the selected item is \(selectedItem) and new : \(Newcontent)")
                //self.param["token"] = String(describing: self.user["response"]["token"])
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                self.param["content"] = Newcontent
                self.request.request(type: "PUT", param: self.param, add: "news/" + String(describing: self.actu[path.section]["id"]), callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.refreshActu()
                    }
                    else {
                        SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                    }
                });

            }
            
            cell.tapped_delete = { [unowned self] (selectedCell, Newcontent) -> Void in
                let path = tableView.indexPathForRow(at: selectedCell.center)!
                let selectedItem = self.actu[path.section]["content"]
                
                print("the selected item is \(selectedItem) and new : \(Newcontent)")
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                self.request.request(type: "DELETE", param: self.param, add: "news/" + String(describing: self.actu[path.section]["id"]) , callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        //self.refreshActu()
                        self.refreshActu()
                        
                    }
                    else {
                        SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                    }
                });

            }
       
        let datefinale = String(describing: actu[indexPath.section]["updated_at"])//.transformToDate() + " à " + String(describing: actu[indexPath.section]["updated_at"]).getHeureFromString()
        //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
            var title = ""
        if actu[indexPath.section]["group_name"] == user["fullname"] {
            title = String(describing: actu[indexPath.section]["volunteer_name"]) + " a publié sur son mur"
        } else {
            title = String(describing: actu[indexPath.section]["volunteer_name"]) + " a publié sur le mur de " + String(describing: actu[indexPath.section]["group_name"])
            }
            
            var from = ""
            if actu[indexPath.section]["volunteer_id"] == user["id"] {
                from = "true"
            }
            else {
                from = "false"
            }
            print("PHOTO PATH == " + define.path_picture + String(describing: actu[indexPath.section]["volunteer_thumb_path"]))
            cell.setCell(NameLabel: title,DateLabel: datefinale, imageName: define.path_picture + String(describing: actu[indexPath.section]["volunteer_thumb_path"]), content: String(describing: actu[indexPath.section]["content"]), from: from)

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as UITableViewCell
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return actu.count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 1.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 140
//        } else {
//            return UITableViewAutomaticDimension
//        }
//    }
    
//    func gradientBackground() {
//        let colorTop =  UIColor(red: 250.0/255.0, green: 255.0/255.0, blue: 209.0/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 161.0/255.0, green: 255.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
//        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [ colorTop, colorBottom]
//        gradientLayer.locations = [ 0.0, 1.0]
//        gradientLayer.frame = self.view.bounds
//        
//        //self.list_Actu.layer.addSublayer(gradientLayer)
//        let back = UIView(frame: self.list_Actu.bounds)
//        back.layer.addSublayer(gradientLayer)
//        self.list_Actu.backgroundView?.addSubview(back)
//    }
    
    @IBAction func goToMenu(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuController
        //Pass delegate and variable to vc which is HomeController
        vc.User = user
        //vc.teststring = "hello"
        
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.gradientBackground()
        mySocket.firstConnection()
        self.list_Actu.addSubview(self.refreshControl)
        //let tbc = self.tabBarController  as! TabBarController
        self.user = sharedInstance.volunteer["response"]
        print("entere : \(self.user)")
        list_Actu.register(UINib(nibName: "CustomCellActu", bundle: nil), forCellReuseIdentifier: "customcellactu")
        list_Actu.estimatedRowHeight = 159.0
        list_Actu.rowHeight = UITableViewAutomaticDimension
        //list_Actu.rowHeight = 44
        //labeltest.text = String(self.user["response"]["firstname"])
        refreshActu()
        
    }
    
    func refreshActu() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        self.request.request(type: "GET", param: self.param, add: "news", callback: {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        if(segue.identifier == "showcommentfromcommenthome"){
            let indexPath = list_Actu.indexPath(for: sender as! UITableViewCell)
            let secondViewController = segue.destination as! CommentActuController
            
            // set a variable in the second view controller with the String to pass
            print("ID = " + String(describing: actu[indexPath!.section]["id"]))
            secondViewController.IDnews = String(describing: actu[indexPath!.section]["id"])
            //secondViewController.user = user
        }
    }

}






