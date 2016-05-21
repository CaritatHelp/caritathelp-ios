//
//  MenuController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 20/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MenuController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var User : JSON = []
    var request = RequestModel()
let numberOfRowsAtSection: [Int] = [3, 1, 2, 1]
    let Titlesections : [String] = ["","",""]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCellWithIdentifier("Menu1", forIndexPath: indexPath)
            }else if indexPath.row == 1{
            cell = tableView.dequeueReusableCellWithIdentifier("Menu2", forIndexPath: indexPath)
        }
        else if indexPath.row == 2{
            cell = tableView.dequeueReusableCellWithIdentifier("Menu3", forIndexPath: indexPath)
        }
        }
        if indexPath.section == 1{
                cell = tableView.dequeueReusableCellWithIdentifier("Menu4", forIndexPath: indexPath)

        }

        if indexPath.section == 2{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCellWithIdentifier("Menu5", forIndexPath: indexPath)
            }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCellWithIdentifier("Menu6", forIndexPath: indexPath)
            }
        }

        if indexPath.section == 3{
                cell = tableView.dequeueReusableCellWithIdentifier("Menu7", forIndexPath: indexPath)
        }

        return cell
    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 7
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
   
    @IBAction func Deconnexion(sender: AnyObject) {
        let param = ["token" : String(User["token"])]
        
        request.request("POST", param: param, add: "logout", callback: {
            (isOK, User) -> Void in
            if (isOK) {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConnectVC") as! ViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }else{
                // do error handling here
                print("erreur de déconnexion")
            }
        })

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let tbc = self.tabBarController  as! TabBarController
        User = sharedInstance.volunteer["response"]

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        // get a reference to the second view controller
        if(segue.identifier == "GoToProfilVol"){
            let secondViewController = segue.destinationViewController as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = String(User["id"])
        }
//        if(segue.identifier == "GestionProfil"){
//            let secondViewController = segue.destinationViewController as! GestionCompte
//            
//            // set a variable in the second view controller with the String to pass
//            secondViewController.user = User
//        }
    }
    

}
