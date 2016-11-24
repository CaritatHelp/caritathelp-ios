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
    
    @IBAction func changeText(_ sender: AnyObject) {
        

        let pseudo = login.text
        let pwd = password.text
        msg_co.text = ""
        LogIn(pseudo: pseudo!, pwd: pwd!)
    }
    
    func getData(status:String){
        
    }
    
    func LogIn(pseudo:String,pwd:String) {
        
        print(pseudo)
        //print(pwd)
        
        let param = ["email": pseudo, "password": pwd]
        //var res : AnyObject = ""
        
        request.request(type: "POST", param: param, add: "auth/sign_in", callback: {
            (isOK, User) -> Void in
            if (isOK) {
                //do good stuff here
//                self.msg_co.text = "Connecté"
//                self.msg_co.textColor = UIColor.greenColor()
                print("USER : \(User["response"]["lastname"])")
                let paramCo = "{\"token\":\"token\", \"token_user\":" + String(describing: User["response"]["token"]) + "}"
                print("TEST 1 : " + paramCo)
                //                self.presentViewController(vc, animated: false, completion: nil)
                sharedInstance.setUser(user: User)
                let storyboard = UIStoryboard(name:"Main",bundle: nil)
                let TBCtrl = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarController
                TBCtrl.user = User
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.window?.rootViewController = TBCtrl

            }else{
                // do error handling here
                self.msg_co.text = "login et/ou mot de passe incorrect"
                self.msg_co.textColor = UIColor.red
            }
        })
    }
    @IBOutlet weak var connexionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.connexionButton.layer.borderWidth = 2.0
        self.connexionButton.layer.borderColor = UIColor.white.cgColor
        self.connexionButton.layer.cornerRadius = 56.0 / 2
        self.connexionButton.titleLabel!.font = UIFont.signinButtonFont()
        self.connexionButton.contentHorizontalAlignment = .center
        login.text = "jeremy@root.com"
        password.text = "root1234"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }

    




}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView {
    func downloadedFrom(link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async { () -> Void in
                self.image = image
            }
        }).resume()
    }
}

