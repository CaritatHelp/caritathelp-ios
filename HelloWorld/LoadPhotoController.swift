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

class LoadPhotoController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var param = [String: String]()
    var request = RequestModel()
    var user : JSON = []
    var image = UIImage()
    var from = ""
    var id_asso = ""
    var id_event = ""
    
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    @IBOutlet weak var PictureLoaded: UIImageView!
    
    @IBAction func LoadPicture(_ sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        user = sharedInstance.volunteer["response"]
        imagePicker.delegate = self
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("de la bibliothèque") {
            print("vers la bibliothèque")
            self.LoadLibrary()
            
        }
        alertView.addButton("appareil photo") {
            print("Second button tapped")
            self.LoadCamera()
        }
        alertView.showSuccess("Modification", subTitle: "Vous souhaitez modifier votre photo de profil via :")
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
        
        let imageToLoad = resizeImage(image: image, newWidth: 200)
        
       let imageData:NSData = UIImagePNGRepresentation(imageToLoad)! as NSData
        let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]

        param["file"] = strBase64
        param["filename"] = "photo_profil.jpg"
        param["original_filename"] = "photo_profil.jpg"
        if (from == "1") {
            param["is_main"] = "true"
        }
        else if(from == "2"){
            param["is_main"] = "true"
            param["assoc_id"] = id_asso
        }
        else if(from == "3"){
            param["is_main"] = "true"
            param["event_id"] = id_event
        }
        let val = "pictures"
        Loader.startAnimating()
        request.request(type: "POST", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.Loader.stopAnimating()
                SCLAlertView().showSuccess("Telechargement terminer", subTitle: "Votre photo de profil a été remplacé !")
            }
            else {
                SCLAlertView().showError("Un problème est survenue", subTitle: "Votre photo de profil n'a pas été remplacé...")
            }
        });

    }
    

    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            PictureLoaded.contentMode = .scaleAspectFit
            PictureLoaded.image = pickedImage
            print(PictureLoaded.image)
            image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
