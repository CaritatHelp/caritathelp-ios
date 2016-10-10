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
    var param = [String: String]()
let numberOfRowsAtSection: [Int] = [4, 1, 2, 1]
    let Titlesections : [String] = ["","",""]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu1", for: indexPath)
            }else if indexPath.row == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "Menu2", for: indexPath)
        }
        else if indexPath.row == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "Menu3", for: indexPath)
        }
        else if indexPath.row == 3{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu4", for: indexPath)
            }
        }
        if indexPath.section == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu5", for: indexPath)

        }

        if indexPath.section == 2{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu6", for: indexPath)
            }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu7", for: indexPath)
            }
        }

        if indexPath.section == 3{
                cell = tableView.dequeueReusableCell(withIdentifier: "Menu8", for: indexPath)
        }

        return cell
    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 7
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
   
    @IBAction func Deconnexion(_ sender: AnyObject) {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        
        self.request.request(type: "POST", param: param, add: "auth/sign_out", callback: {
            (isOK, User) -> Void in
            if (isOK) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConnectVC") as! ViewController
                self.present(vc, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        // get a reference to the second view controller
        if(segue.identifier == "GoToProfilVol"){
            let secondViewController = segue.destination as! ProfilVolunteer
            
            // set a variable in the second view controller with the String to pass
            secondViewController.idvolunteer = String(describing: User["id"])
        }
//        if(segue.identifier == "GestionProfil"){
//            let secondViewController = segue.destinationViewController as! GestionCompte
//            
//            // set a variable in the second view controller with the String to pass
//            secondViewController.user = User
//        }
    }
    

}
