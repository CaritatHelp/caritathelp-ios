//
//  GalleryAssoViewController.swift
//  Caritathelp
//
//  Created by Jeremy gros on 18/11/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import NYTPhotoViewer

class GalleryAssoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NYTPhotosViewControllerDelegate {
    @IBOutlet weak var gallery: UICollectionView!

    var assoID = ""
    var volunteerID = ""
    var eventID = ""
    var request = RequestModel()
    private var photo : JSON = []
    var photos : [NYTPhoto]!
    var rights = ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photo.count
    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomCellGallery = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CustomCellGallery
        
        print("\(self.photo[indexPath.row]["picture_path"]["thumb"]["url"]))")
        
        cell.setCell(imageName: define.path_picture + String(describing: self.photo[indexPath.row]["picture_path"]["thumb"]["url"]))
        
        cell.backgroundColor = UIColor.orange
        cell.layer.cornerRadius = 2.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 1.0
        cell.layer.masksToBounds = false
        
        cell.showImages = { [unowned self] (selectedCell, photo) -> Void in
            //let imageData: NSData = UIImagePNGRepresentation(photo)
            self.photos = PhotosProvider().photos(image: photo)
            let photosViewController = NYTPhotosViewController(photos: self.photos)
            photosViewController.delegate = self
            self.present(photosViewController, animated: true, completion: nil)
        }
        //cell.clipsToBounds = true
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: self.view.frame.size.width/3, height: self.view.frame.size.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        
        //self.gallery.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addPicture))
        refreshButton.tintColor = UIColor.GreenBasicCaritathelp()
        if assoID != "" && rights == "owner" {
            navigationItem.rightBarButtonItem = refreshButton
        }
        if eventID != "" && rights == "host" {
            navigationItem.rightBarButtonItem = refreshButton
        }
        if volunteerID == String(describing: sharedInstance.volunteer["response"]["id"]) {
            navigationItem.rightBarButtonItem = refreshButton
        }
        self.loadImage()
    }
    
    func addPicture() {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "managePhoto") as! ManagePhotoController
            vc.from = "2"
            vc.id_asso = self.assoID
            vc.state = "false"
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadImage() {
        var param = [String: String]()
        var val = ""
        if assoID != "" {
            val = "associations/" + self.assoID + "/pictures"
        }
        else if eventID != "" {
            val = "events/" + self.eventID + "/pictures"
        }
        else if volunteerID != "" {
            val = "volunteers/" + self.volunteerID + "/pictures"
            param["access-token"] = sharedInstance.header["access-token"]
            param["client"] = sharedInstance.header["client"]
            param["uid"] = sharedInstance.header["uid"]

        }
        self.request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.photo = User["response"]
                self.gallery.reloadData()
            }
            else {
                
            }
        });

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class CustomCellGallery: UICollectionViewCell {
    
    @IBOutlet weak var ImageProfilFriends: UIImageView!
    var showImages: ((CustomCellGallery, UIImage) -> Void)?
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var isSelected: Bool {
        didSet {
            self.actionView()
        }
    }
    
    func actionView() {
        let photo = self.ImageProfilFriends.image
        self.showImages!(self, photo!)
//        let photosViewController = NYTPhotosViewController(photos: self.photos)
//        photosViewController.delegate = self
//        presentViewController(photosViewController, animated: true, completion: nil)
    }

    func setCell(imageName: String){
        self.ImageProfilFriends.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.ImageProfilFriends.layer.cornerRadius = 2.0
        //self.ImageProfilFriends.layer.borderColor = UIColor.darkGray.cgColor;
        self.ImageProfilFriends.layer.masksToBounds = true
        self.ImageProfilFriends.clipsToBounds = true
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
}

class ExamplePhoto: NSObject, NYTPhoto {
    
    var image: UIImage?
    var imageData: Data?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    let attributedCaptionSummary: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.gray])
    let attributedCaptionCredit: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
    
    init(image: UIImage? = nil, imageData: NSData? = nil, attributedCaptionTitle: NSAttributedString) {
        self.image = image
        self.imageData = imageData as Data?
        self.attributedCaptionTitle = attributedCaptionTitle
        super.init()
    }
    
}

class PhotosProvider: NSObject {
    
//    var tof: UIImage!
//    
//    init(photo: UIImage) {
//        self.tof = photo
//    }
    
    func photos(image: UIImage? = nil) -> [ExamplePhoto] {
        
        var mutablePhotos: [ExamplePhoto] = []
            let title = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.white])
            
            let photo = ExamplePhoto(image: image, attributedCaptionTitle: title)
            
            mutablePhotos.append(photo)
        
        return mutablePhotos
    }
}
