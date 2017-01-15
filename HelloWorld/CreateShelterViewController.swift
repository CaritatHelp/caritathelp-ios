//
//  CreateShelterViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 04/12/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SnapKit
import SCLAlertView
import SwiftyJSON
import MapKit

class CreateShelterViewController: UIViewController {

    enum Component: Int {
        case Name
        case Adress
        case Zipcode
        case City
        case Places
        case Disponibility
        case Phone
        case Mail

        static var all: [Component] = [.Name, .Adress, .Zipcode, .City, .Places, .Disponibility, .Phone, .Mail]
        
        var placeholder: String {
            switch self {
            case .Name:
                return "nom du centre"
            case .Adress:
                return "Adresse"
            case .Zipcode:
                return "code postale"
            case .City:
                return "ville"
            case .Places:
                return "nombre de places"
            case .Disponibility:
                return "nombre de places disponibles"
            case .Phone:
                return "téléphone"
            case .Mail:
                return "e-mail"
            }
        }
        
        static func name(index: Int) -> String {
            switch index {
            case 0:
                return "name"
            case 1:
                return "address"
            case 2:
                return "zipcode"
            case 3:
                return "city"
            case 4:
                return "total_places"
            case 5:
                return "free_places"
            case 6:
                return "phone"
            case 7:
                return "mail"
            default:
                return ""
            }
        }
    }
    
    var textFields = [UITextField]()
    private var bottomTextFields = [UIView]()
    private var components = Component.all
    private var createButton = UIButton()
    private var loader = UIActivityIndicatorView()
    var create = true
    var longitude = ""
    var latitude = ""
    
    var user : JSON = []
    var AssocID = ""
    var request = RequestModel()
    var param = [String: String]()
    var shelter: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.greenCaritathelp()
        
        var offset = 80.0
        var offsetBottom = 115.0
        for (i, element) in components.enumerated() {
            let textField = UITextField()
            textField.placeholder = element.placeholder
            //textField.backgroundColor = UIColor.greenCaritathelp()
            textField.textAlignment = .center
            textField.tintColor = UIColor.white
            textField.textColor = UIColor.white
            if element == .Phone || element == .Places || element == .Disponibility || element == .Zipcode {
                textField.keyboardType = .decimalPad
            }
            if !create {
                textField.text = String(describing: shelter[Component.name(index: i)])
            }
            
            self.textFields.append(textField)
            self.view.addSubview(textField)
            
            let view = UIView()
            view.backgroundColor = UIColor.lightGray
            self.bottomTextFields.append(view)
            self.view.addSubview(view)

            
            textField.snp.makeConstraints({ make in
                make.height.equalTo(30.0)
                make.width.equalTo(250.0)
                make.centerX.equalTo(self.view)
                make.top.equalTo(self.view).offset(offset)
            })
            
            view.snp.makeConstraints { (make) in
                make.height.equalTo(1.0)
                make.width.equalTo(self.view.frame.width-20.0)
                make.centerX.equalTo(self.view)
                make.top.equalTo(self.view).offset(offsetBottom)
                
            }
            
            offset += 60.0
            offsetBottom += 59.0
        }
        if create {
            self.createButton.setTitle("Créer", for: .normal)
        }
        else {
            self.createButton.setTitle("Modifier", for: .normal)
        }
        self.createButton.setTitleColor(UIColor.white, for: .normal)
        self.createButton.layer.borderWidth = 2.0
        self.createButton.layer.borderColor = UIColor.white.cgColor
        self.createButton.layer.cornerRadius = 41.0 / 2
        self.createButton.titleLabel!.font = UIFont.signinButtonFont()
        self.createButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        self.createButton.addTarget(self, action: #selector(createShelter), for: .touchUpInside)
        
        self.view.addSubview(self.createButton)
        self.createButton.snp.makeConstraints { (make) in
            make.height.equalTo(40.0)
            make.width.equalTo(100.0)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-20.0)
        }
        
        self.view.addSubview(self.loader)
        self.loader.snp.makeConstraints { (make) in
            make.height.width.equalTo(15.0)
            make.centerY.equalTo(self.createButton)
            make.left.equalTo(self.createButton.snp.right).offset(20.0)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocalisation(_ address: String, completion:@escaping ((_ finished: Bool) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let placemark = placemarks[0] as CLPlacemark
                    let location = placemark.location
                    
                    self.latitude = String(describing: location!.coordinate.latitude)
                    self.longitude = String(describing: location!.coordinate.longitude)
                    
                    print("before : \(self.latitude, self.longitude, placemark.country)")
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
            else {
                completion(false)
            }
        }
    }
    
    func getAddress() -> String {
        var address = ""
        for txtField in textFields {
            if txtField.placeholder == "Adresse" {
                address += txtField.text! + " "
            }
            
            if txtField.placeholder == "code postale" {
                address += txtField.text! + " "
            }
            
            if txtField.placeholder == "ville" {
                address += txtField.text!
            }
        }
        return address
    }
    
    func createShelter() {
        if self.verifyComponent() {
            self.loader.startAnimating()
            self.getLocalisation(getAddress()) { (finished) in
                if finished {
                    self.param["access-token"] = sharedInstance.header["access-token"]
                    self.param["client"] = sharedInstance.header["client"]
                    self.param["uid"] = sharedInstance.header["uid"]
                    self.param["assoc_id"] = self.AssocID
                    self.param["latitude"] = self.latitude
                    self.param["longitude"] = self.longitude
                    var index = 0
                    for textfield in self.textFields {
                        self.param[Component.name(index: index)] = textfield.text
                        index += 1
                    }
                    
                    var type = "POST"
                    var val = "shelters"
                    if !self.create {
                        type = "PUT"
                        val = "shelters/" + String(describing: self.shelter["id"])
                    }
                    
                    self.request.request(type: type, param: self.param,add: val, callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            if User["status"] == 200 {
                                if self.create {
                                    SCLAlertView().showSuccess("Succès !", subTitle: "La création de votre centre est un succès!")
                                }
                                else {
                                    SCLAlertView().showSuccess("Succès !", subTitle: "La modification de votre centre est un succès!")
                                }
                                _ = self.navigationController?.popViewController(animated: true)
                                self.loader.stopAnimating()
                            } else {
                                SCLAlertView().showError("Erreure", subTitle: String(describing: User["message"]))
                            }
                        }
                        else {
                            
                        }
                    });
                }
            }
        }
    }

    func verifyComponent() -> Bool {
        for textfield in textFields {
            if (textfield.text?.isEmpty)! {
                SCLAlertView().showError("Incomplet", subTitle: "Veuillez remplir tous les champs.")
                return false
            }
            if textfield.placeholder == "e-mail" {
                if textfield.text?.range(of: "@") == nil {
                    SCLAlertView().showError("E-mail invalide", subTitle: "veuillez renseigner un mail valide")
                    return false
                }
            }
            //number verif ?
            if textfield.placeholder == "" {
                
            }
            
        }
        return true
    }
}

extension CreateShelterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("tap number")
        for textfield in textFields {
            if textfield.placeholder == "téléphone" {
                print("téléphone")
                if (textfield.text?.characters.count)! > 10{
                    print("stop")
                    return false
                }
            }

        }
        return true
    }
}
