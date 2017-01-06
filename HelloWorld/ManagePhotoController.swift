//
//  LoadPhotoController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 04/06/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class ManagePhotoController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var param = [String: String]()
    var request = RequestModel()
    var user : JSON = []
    var image: UIImage!
    var from = ""
    var state = ""
    var id_asso = ""
    var id_event = ""
    
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    @IBOutlet weak var PictureLoaded: UIImageView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var validButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        imagePicker.delegate = self
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("de la bibliothèque") {
            self.LoadLibrary()
            
        }
        alertView.addButton("appareil photo") {
            self.LoadCamera()
        }
        alertView.showSuccess("Modification", subTitle: "Vous souhaitez modifier votre photo de profil via :")
        
        self.cameraButton.layer.borderWidth = 2.0
        self.cameraButton.layer.borderColor = UIColor.GreenBasicCaritathelp().cgColor
        self.cameraButton.layer.cornerRadius = 41.0 / 2
        self.cameraButton.titleLabel!.font = UIFont.signinButtonFont()
        self.cameraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        self.libraryButton.layer.borderWidth = 2.0
        self.libraryButton.layer.borderColor = UIColor.GreenBasicCaritathelp().cgColor
        self.libraryButton.layer.cornerRadius = 41.0 / 2
        self.libraryButton.titleLabel!.font = UIFont.signinButtonFont()
        self.libraryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
       
        self.validButton.layer.borderWidth = 2.0
        self.validButton.layer.borderColor = UIColor.GreenBasicCaritathelp().cgColor
        self.validButton.layer.cornerRadius = 32.0 / 2
        self.validButton.titleLabel!.font = UIFont.signinButtonFont()
        self.validButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center

    }
    
    
    @IBAction func CallCamera(_ sender: AnyObject) {
        LoadCamera()
    }
    @IBAction func CallLibrary(_ sender: AnyObject) {
        LoadLibrary()
    }
    
    func LoadLibrary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func LoadCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                present(imagePicker, animated: true, completion: {})
            } else {
                SCLAlertView().showError("Echec", subTitle: "Vous n'avez pas de camera.")
            }
        } else {
            SCLAlertView().showError("Echec", subTitle: "Impossible d'accéder à votre camera.")
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth,height: newHeight))
        image.draw(in: CGRect(x:0,y: 0,width: newWidth,height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
    @IBAction func DownloadPicture(_ sender: AnyObject) {
        
        if self.image != nil {
        let imageToLoad = resizeImage(image: self.image, newWidth: 480)
        
       let imageData:NSData = UIImagePNGRepresentation(imageToLoad)! as NSData
        let strBase64:String = imageData.base64EncodedString()
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        self.param["file"] = strBase64
        self.param["filename"] = "photo_profil.jpg"
        self.param["original_filename"] = "photo_profil.jpg"
        if (from == "1") {
            self.param["is_main"] = self.state
        }
        else if(from == "2"){
            self.param["filename"] = "photo_gallery.jpg"
            self.param["original_filename"] = "photo_gallery.jpg"
            self.param["is_main"] = self.state
            self.param["assoc_id"] = self.id_asso
        }
        else if(from == "3"){
            self.param["is_main"] = self.state
            self.param["event_id"] = self.id_event
        }
        let val = "pictures"
        self.Loader.startAnimating()
        self.request.request(type: "POST", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Loader.stopAnimating()
                _ = self.navigationController?.popViewController(animated: true)
                SCLAlertView().showSuccess("Telechargement terminer", subTitle: "Votre photo de profil a été remplacé !")
            }
            else {
                SCLAlertView().showError("Un problème est survenue", subTitle: "Votre photo de profil n'a pas été remplacé...")
            }
        });
        }
        else {
          SCLAlertView().showError("Aucune photo", subTitle: "selectionner ou prenez une photo!")
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Before *****")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] {
            print("INDSIDE ====")
            PictureLoaded.contentMode = .scaleAspectFit
            PictureLoaded.image = pickedImage as? UIImage
            image = PictureLoaded.image!
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }
}
