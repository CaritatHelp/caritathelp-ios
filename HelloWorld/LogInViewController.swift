//
//  LogInViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 11/11/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class LogInViewController: UIViewController {
    private var request = RequestModel()
    private var mail: UITextField!
    private var password: UITextField!
    private var separator1: UIView!
    private var separator2: UIView!
    private var signInButton: UIButton!
    private var signUpButton: UIButton!
    private var errorLabel: UILabel!
    private var beforeSignUpLabel: UILabel!
    private var logo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "2017_logo_caritathelp"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let backgroundColor = self.gradientBackground()
        backgroundColor.frame = self.view.bounds
        self.view.layer.addSublayer(backgroundColor)
        
        // Mail
        self.mail = UITextField()
        self.mail.placeholder = "e-mail"
        self.mail.textColor = UIColor.darkGray
        self.mail.textAlignment = .center
        self.mail.tintColor = UIColor.lightGray
        self.mail.autocapitalizationType = .none
        self.view.addSubview(self.mail)
        
        self.mail.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.width.equalTo(250.0)
            make.top.equalTo(self.view).offset(150.0)
            make.centerX.equalTo(self.view)
        }
        
        // Separator
        self.separator1 = UIView()
        self.separator1.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.separator1)
        
        self.separator1.snp.makeConstraints { (make) in
            make.height.equalTo(1.0)
            make.width.equalTo(250.0)
            make.top.equalTo(self.mail.snp.bottom).offset(2.0)
            make.centerX.equalTo(self.view)
        }
        
        // password
        self.password = UITextField()
        self.password.placeholder = "mot de passe"
        self.password.textColor = UIColor.darkGray
        self.password.textAlignment = .center
        self.password.tintColor = UIColor.lightGray
        self.password.isSecureTextEntry = true
        self.view.addSubview(self.password)
        
        self.password.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.width.equalTo(250.0)
            make.top.equalTo(self.separator1.snp.bottom).offset(10.0)
            make.centerX.equalTo(self.view)
        }
        
        // Separator
        self.separator2 = UIView()
        self.separator2.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.separator2)
        
        self.separator2.snp.makeConstraints { (make) in
            make.height.equalTo(1.0)
            make.width.equalTo(250.0)
            make.top.equalTo(self.password.snp.bottom).offset(2.0)
            make.centerX.equalTo(self.view)
        }
        
        // Sign In
        self.signInButton = UIButton()
        //self.signInButton.layer.borderWidth = 2.0
        //self.signInButton.layer.borderColor = UIColor.white.cgColor
        self.signInButton.backgroundColor = UIColor.GreenBasicCaritathelp()
        self.signInButton.setTitleColor(UIColor.white, for: .normal)
        self.signInButton.setTitle("Se connecter", for: .normal)
        self.signInButton.layer.cornerRadius = 20.0
        self.signInButton.titleLabel!.font = UIFont.signinButtonFont()
        self.signInButton.contentHorizontalAlignment = .center
        self.signInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        self.view.addSubview(self.signInButton)
        
        self.signInButton.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.width.equalTo(250.0)
            make.top.equalTo(self.separator2.snp.bottom).offset(40.0)
            make.centerX.equalTo(self.view)
        }
        
        // Before Sign Up
        self.beforeSignUpLabel = UILabel()
        self.beforeSignUpLabel.text = "Toujours pas inscrit ?"
        self.beforeSignUpLabel.textColor = UIColor.lightGray
        self.beforeSignUpLabel.textAlignment = .center
        self.beforeSignUpLabel.font = UIFont.onboardingCommentFont()
        self.view.addSubview(self.beforeSignUpLabel)
        self.beforeSignUpLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.width.equalTo(200.0)
            make.top.equalTo(self.signInButton.snp.bottom).offset(20.0)
            make.centerX.equalTo(self.view)
        }
        
        //Sign Up
        self.signUpButton = UIButton()
        self.signUpButton.setTitle("S'inscrire", for: .normal)
        self.signUpButton.setTitleColor(UIColor.white, for: .normal)
        self.signUpButton.setTitleShadowColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        self.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        self.view.addSubview(self.signUpButton)
        self.signUpButton.snp.makeConstraints { (make) in
            make.height.equalTo(15.0)
            make.width.equalTo(100.0)
            make.top.equalTo(self.beforeSignUpLabel.snp.bottom).offset(5.0)
            make.centerX.equalTo(self.view)
        }
        
        // Error Label
        self.errorLabel = UILabel()
        self.errorLabel.textColor = UIColor.red
        self.errorLabel.textAlignment = .center
        self.errorLabel.text = ""
        self.errorLabel.numberOfLines = 2
        self.view.addSubview(self.errorLabel)
        
        self.errorLabel.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.width.equalTo(250.0)
            make.top.equalTo(self.signUpButton.snp.bottom).offset(10.0)
            make.centerX.equalTo(self.view)
        }

        // Logo
        self.view.addSubview(self.logo)
        self.logo.snp.makeConstraints { (make) in
            make.height.equalTo(100.0)
            make.width.equalTo(200.0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-80.0)
            make.centerX.equalTo(self.view)
        }

        self.mail.text = "jeremy@root.com"
        self.password.text = "root1234"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logIn() {
        let param = ["email": self.mail.text!, "password": self.password.text!]
        print("\(self.mail.text!) + \(self.password.text!)")
        request.request(type: "POST", param: param, add: "auth/sign_in", callback: {
            (isOK, User) -> Void in
            if (isOK) {
                if User["status"] == 200 {
                    sharedInstance.setUser(user: User)
                    sharedInstance.AcceptGeolocalisation()
                    let storyboard = UIStoryboard(name:"Main",bundle: nil)
                    let TBCtrl = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarController
                    TBCtrl.user = User
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.window?.rootViewController = TBCtrl
                }
                else {
                    self.errorLabel.text = String(describing: User["message"])
                }
                
            }else{
                // do error handling here
                self.errorLabel.text = "login et/ou mot de passe incorrect"
            }
        })

    }
    
    func signUp() {
        let storyboard = UIStoryboard(name:"Main",bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscribeNameVC") as! SubscribeCtrl
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
}
