//
//  ViewController.swift
//  HelloWorld
//
//  Created by Jeremy gros on 08/12/2015.
//  Copyright © 2015 Jeremy gros. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Starscream

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var login: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var msg_co: UILabel!
    
    var request = RequestModel()
    //let ws = ConnectionWebSocket()
    //var volunteer = VolunteerModel()
    
    @IBAction func changeText(sender: AnyObject) {
        

        let pseudo = login.text
        let pwd = password.text
        msg_co.text = ""
        LogIn(pseudo!, pwd: pwd!)
    }
    
    func getData(status:String){
        
    }
    
    func LogIn(pseudo:String,pwd:String) {
        
        //print(pseudo)
        //print(pwd)
        
        let param = ["mail": pseudo, "password": pwd]
        //var res : AnyObject = ""
        
        request.request("POST", param: param, add: "login", callback: {
            (isOK, User) -> Void in
            if (isOK) {
                //do good stuff here
//                self.msg_co.text = "Connecté"
//                self.msg_co.textColor = UIColor.greenColor()
                print("USER : \(User["response"]["lastname"])")
                let paramCo = "{\"token\":\"token\", \"token_user\":" + String(User["response"]["token"]) + "}"
                print("TEST 1 : " + paramCo)
                ws.firstConnection()
                
                //                self.presentViewController(vc, animated: false, completion: nil)
                sharedInstance.setUser(User)
                let storyboard = UIStoryboard(name:"Main",bundle: nil)
                let TBCtrl = storyboard.instantiateViewControllerWithIdentifier("TabBarVC") as! TabBarController
                TBCtrl.user = User
                let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appdelegate.window?.rootViewController = TBCtrl

            }else{
                // do error handling here
                self.msg_co.text = "login et/ou mot de passe incorrect"
                self.msg_co.textColor = UIColor.redColor()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        login.text = "jeremy@root.com"
        password.text = "root"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }

    




}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
    
}

