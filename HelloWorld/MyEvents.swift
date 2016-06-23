//
//  MyEvents.swift
//  Caritathelp
//
//  Created by Jeremy gros on 17/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyEventsController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user : JSON = []
    var request = RequestModel()
    var param = [String: String]()
    var events : JSON = []
    var nb_row = 0
    var events_past :JSON = []
    var events_created : JSON = []
    var events_futur : JSON = []
    var tabDate = [String]()
    var nbRowinnSect = [Int]()
    var index = 0
    var nb_past = 1
    var nb_futur = 1
    var nb_created = 1
    
    @IBOutlet weak var btnCreatedEvent: UIBarButtonItem!
    @IBOutlet weak var btnFuturEvent: UIBarButtonItem!
    @IBOutlet weak var events_list: UITableView!
    @IBOutlet weak var btnPastEvent: UIBarButtonItem!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCellMyEvents = events_list.dequeueReusableCellWithIdentifier("MyEventsCell", forIndexPath: indexPath) as! CustomCellMyEvents
        let str = String(events[index]["begin"])
        let heure = str[str.startIndex.advancedBy(11)...str.startIndex.advancedBy(15)]
        //let range = Range(start: String(events[index]["begin"]).startIndex.advancedBy(11), end: String(events[index]["begin"]).startIndex.advancedBy(16))
        //        cell.textLabel!.text = String(events["response"][indexPath.row]["title"])
        cell.setCell(String(events[index]["title"]), imageName: String(events[index]["thumb_path"]), state: heure)
        
        index += 1
            return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows : Int = 0
        if section < nbRowinnSect.count {
            rows = nbRowinnSect[section]
        }
        print("rows : " + String(rows))
        return rows
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var total = events.count
        var i = 0
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        tabDate = []
        nbRowinnSect = []
        while i < total{
            //let date = NSDate(dateString : String(events[i]["begin"]))
            
//            print("/"+String(events[i]["begin"])+"/")
//            let date = dateFormatter.dateFromString(String(events[i]["begin"]))
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let date1 = dateFormatter.stringFromDate(date!)
//            print(1)
            let target = String(events[i]["begin"])
            let range = target.startIndex.advancedBy(10)
            let date = target.substringToIndex(range)
            //print(date)
            self.tabDate.append(String(date))
            i += 1
        }
        
        //let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        
        total = uniq(tabDate).count
        let total2 = events.count
        i = 0
        var j = 0
        var count = 0
        while j < total {
            count = 0
            i = 0
            //print("date2 : " + String(tabDate[j]))
            while i < total2{
                let range = String(events[i]["begin"]).startIndex.advancedBy(10)
                if String(tabDate[j]) == String(events[i]["begin"]).substringToIndex(range) {
                //if date1!.compare((date2)!) == NSComparisonResult.OrderedSame {
                        count += 1
                }
                i += 1
            }
           // print(count)
            nbRowinnSect.append(count)
            j += 1
        }
        
        
        let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, events_list.bounds.size.width, events_list.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.Center
        
        if(events.count == 0 && nb_futur == 0){
            noDataLabel.text = "Vous n'avez aucun evenement prochainement"
        }else if(events.count == 0 && nb_created == 0){
            noDataLabel.text = "Vous n'avez créer aucun évènement"
        }else if(events.count == 0 && nb_past == 0){
            noDataLabel.text = "Vous n'avez participer à aucun evenement"
        }
        else{
            noDataLabel.text = ""
        }
        events_list.backgroundView = noDataLabel
        
        return uniq(tabDate).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(tabDate[section])
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        let datefinale = dateFormatter.stringFromDate(date!)
        return datefinale
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    
    func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //events_list.contentInset = UIEdgeInsetsZero
        self.automaticallyAdjustsScrollViewInsets = false
        btnFuturEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        events_list.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        param["token"] = String(user["token"])
        let val = "volunteers/" + String(user["id"]) + "/events"
        request.request("GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                //self.events = User
                let currentDate = NSDate()
                var TableData:Array< JSON > = Array < JSON >()
                var TableData2:Array< JSON > = Array < JSON >()
                var TableData3:Array< JSON > = Array < JSON >()
                let dateFormatter = NSDateFormatter()
                let total = User["response"].count
                var i = 0
                while i < total{
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    //print(String(User["response"][i]["begin"]))
                    let range = String(User["response"][i]["begin"]).startIndex.advancedBy(10)
                    let currentdate = dateFormatter.stringFromDate(currentDate)
                    let date = String(User["response"][i]["begin"]).substringToIndex(range)
                    print(currentDate)
                    print(date)
                    print("----")
                    if currentdate > date  {
                        TableData2.append(User["response"][i])
                    }else {
                        
                        if(User["response"][i]["rights"] == "host"){
                            //self.asso_created_list.rawValue
                            TableData.append(User["response"][i])
                            
                        }
                        else {
                            TableData3.append(User["response"][i])
                        }
                    }
                    i += 1
                }
                self.events_past = JSON(TableData2)
                self.events_created = JSON(TableData)
                self.events_futur = JSON(TableData3)
                self.events = self.events_futur
                self.nb_futur = self.events.count
                self.events_list.reloadData()
            }
            else {
                
            }
        });
        
        
    }
    @IBAction func loadPastEvent(sender: AnyObject) {
        btnPastEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        btnFuturEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        btnCreatedEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        events = events_past
        nb_past = events_past.count
        index = 0
        events_list.reloadData()
    }
    
    @IBAction func loadFuturEvent(sender: AnyObject) {
        btnFuturEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        btnPastEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        btnCreatedEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        self.events = events_futur
        nb_futur = events_futur.count
        index = 0
        events_list.reloadData()
        
    }
    @IBAction func loadCreatedEvent(sender: AnyObject) {
        btnCreatedEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        btnFuturEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        btnPastEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        events = events_created
        nb_created = events_created.count
        index = 0
        events_list.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventProfilVC2"){
            let indexPath = events_list.indexPathForCell(sender as! UITableViewCell)
            //            let currentCell = events_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destinationViewController as! ProfilEventController
            
            var i = 0
            var newindex = 0;
            while i < indexPath!.section{
                newindex += nbRowinnSect[i]
                i += 1
            }
            newindex += indexPath!.row
            //print("..............")
            //print(newindex)
            //print("..............")
            // set a variable in the second view controller with the String to pass
            print(events["response"])
            print("*$$$$$$$*************")
            secondViewController.EventID = String(events[newindex]["id"])
            //secondViewController.user = user
            print(indexPath?.row);
            //navigationItem.title = "back"
        }
    }

}

//extension MyEventsController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        
//        return events.count + 5
//    }
//    
//    func collectionView(collectionView: UICollectionView,
//                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellCreatedEvent", forIndexPath: indexPath)
//        return cell
//    }
//}

