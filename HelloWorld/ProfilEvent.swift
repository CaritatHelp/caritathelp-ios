//
//  ProfilEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 16/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class ProfilEventController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //variable utilisé dans cette classe
    var param = [String: String]()
    var request = RequestModel()
    var EventID : String = ""
    var Event : JSON = []
    var user : JSON = []
    var main_picture = ""
    
    
    @IBOutlet weak var imageEvent: UIImageView!
    //variable en lien avec la storyBoard
    @IBOutlet weak var StateMembersOnEvent: UIButton!
    @IBOutlet weak var eventsNewsList: UITableView!
    @IBOutlet weak var JoinEventBtn: UIBarButtonItem!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventsNewsList.dequeueReusableCellWithIdentifier("EventNewsCell", forIndexPath: indexPath)
        
//        cell.textLabel!.text = String(events["response"][indexPath.row]["title"])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    @IBAction func JoinEvent(sender: AnyObject) {
        //quitter un event en tant que membre
        if(String(Event["response"]["rights"]) == "member"){
            param["token"] = String(user["token"])
            param["event_id"] = EventID
            let val = "guests/leave"
            request.request("DELETE", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.JoinEventBtn.image = UIImage(named: "event_not_joined")
                    //self.tableViewAssoc.reloadData()
                }
                else {
                    SCLAlertView().showError("Attention", subTitle: "une erreur est survenue...")
                }
            });

        }
            //empecher a l'host de quitter
        else if (String(Event["response"]["rights"]) == "host"){
            SCLAlertView().showError("Attention", subTitle: "Vous avez créé cet évènement \n Vous ne pouvez le quitter !")
        }
        else if (String(Event["response"]["rights"]) == "waiting"){
            SCLAlertView().showError("En attente", subTitle: "le créateur de l'évènement est en train de traiter votre demande !")
        }
        else{//Rejoindre l'event (envoyer une demande à l'host)
            param["token"] = String(user["token"])
            param["event_id"] = EventID
            let val = "guests/join"
            request.request("POST", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    SCLAlertView().showTitle(
                        "Demande envoyé", // Title of view
                        subTitle: "Vous receverez une notification concernant le retour de l'association", // String of view
                        duration: 10.0, // Duration to show before closing automatically, default: 0.0
                        completeText: "ok", // Optional button value, default: ""
                        style: .Success, // Styles - see below.
                        colorStyle: 0x22B573,
                        colorTextButton: 0xFFFFFF
                    )
                    let imageBtnWait = UIImage(named: "waiting")
                    let newimage = self.resizeImage(imageBtnWait!, newWidth: 30)
                    self.JoinEventBtn.image = newimage
                    
                    //self.tableViewAssoc.reloadData()
                }
                else {
                    SCLAlertView().showError("Attention", subTitle: "une erreur est survenue...")
                }
            });
        }

    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(EventID)
        print("----------")
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "events/" + EventID
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                //test currentEvent save
                currentEvent.currentEvent = User["response"]
                print(currentEvent.currentEvent["title"])
                self.Event = User
                if (String(self.Event["response"]["rights"]) == "waiting"){
                let imageBtnWait = UIImage(named: "waiting")
                let newimage = self.resizeImage(imageBtnWait!, newWidth: 30)
                self.JoinEventBtn.image = newimage
                }
                self.navigationItem.title = String(self.Event["response"]["title"])
                if(String(self.Event["response"]["rights"]) == "host" || String(self.Event["response"]["rights"]) == "member"){
                    self.JoinEventBtn.image = UIImage(named: "event_joined")
                }
                let val2 = "/events/" + self.EventID + "/main_picture"
                self.request.request("GET", param: self.param,add: val2, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.main_picture = define.path_picture + String(User["response"]["picture_path"]["url"])
                        self.imageEvent.downloadedFrom(link: self.main_picture, contentMode: .ScaleAspectFit)
                    }
                    else {
                        
                    }
                });

                
                //self.tableViewAssoc.reloadData()
            }
            else {
                SCLAlertView().showError("Attention", subTitle: "une erreur est survenue...")
            }
        });
    }
    
    override func viewWillAppear(animated: Bool) {
        print(currentEvent.currentEvent["title"])
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventInfoVC"){
            let secondViewController = segue.destinationViewController as! InformationsEvent
            
            // set a variable in the second view controller with the String to pass
           
            secondViewController.Event = Event
        }
        if(segue.identifier == "EventMembersVC"){
            let secondViewController = segue.destinationViewController as! MembersEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(Event["response"]["id"])
            secondViewController.AssoID = String(Event["response"]["assoc_id"])
        }
        if(segue.identifier == "gotopostfromevent"){
            let secondViewController = segue.destinationViewController as! PostStatutAssoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(Event["response"]["id"])
            secondViewController.from = "event"
        }
        if(segue.identifier == "goToUpdateEvent"){
            let secondViewController = segue.destinationViewController as! UpdateEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.Event = Event["response"]
        }
        if(segue.identifier == "fromevent"){
            let secondViewController = segue.destinationViewController as! LoadPhotoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.id_event = String(Event["response"]["id"])
            secondViewController.from = "3"
            
        }

    }//goToInviteGuest

    
}