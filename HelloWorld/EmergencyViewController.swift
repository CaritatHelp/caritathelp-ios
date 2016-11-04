//
//  EmergencyViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 03/11/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class EmergencyViewController: UIViewController {

    @IBOutlet weak var TitleEmergency: UILabel!
    @IBOutlet weak var show_invit: UILabel!
    @IBOutlet weak var show_km: UILabel!
    @IBOutlet weak var nb_invit: UISlider!
    @IBOutlet weak var nb_km: UISlider!
    @IBOutlet weak var emergencyButton: UIButton!
    var user : JSON = []
    var param = [String: String]()
    var request = RequestModel()
    var eventID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGreenCaritathelp()

        self.nb_km.tintColor = UIColor.GreenBasicCaritathelp()
        self.nb_invit.tintColor = UIColor.GreenBasicCaritathelp()
        self.TitleEmergency.text = "Paramètrer votre urgence !"
        self.emergencyButton.setTitleColor(UIColor.GreenBasicCaritathelp(), for: .normal)
        
        
        self.show_km.text = String(Int(self.nb_km.value))
        self.show_invit.text = String(Int(self.nb_invit.value))
        
        self.emergencyButton.layer.borderWidth = 2.0
        self.emergencyButton.layer.borderColor = UIColor.GreenBasicCaritathelp().cgColor
        self.emergencyButton.layer.cornerRadius = 56.0 / 2
        self.emergencyButton.titleLabel!.font = UIFont.signinButtonFont()
        self.emergencyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func modifyInvit(_ sender: Any) {
        self.show_invit.text = String(Int(self.nb_invit.value))
    }
    
    @IBAction func modifyKm(_ sender: Any) {
        self.show_km.text = String(Int(self.nb_km.value))
    }

    @IBAction func sendEmergency(_ sender: Any) {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        self.param["number_volunteers"] = String(Int(self.nb_invit.value))
        self.param["zone"] = String(Int(self.nb_km.value))
        
        print("avant emergency")
        request.request(type: "POST", param: self.param,add: "events/" + self.eventID + "/raise_emergency", callback: {
            (isOK, User)-> Void in
            if(isOK){
                if User["status"] != 200 {
                    SCLAlertView().showError("Erreur", subTitle: String(describing: User["message"]))
                }
                else{
                    SCLAlertView().showSuccess("Urgence envoyée !", subTitle: "Les volontaires sont contactés en ce moment même.")
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                SCLAlertView().showError("Erreur", subTitle: "Une erreure est survenue.")
            }
        });

          }
   
}
