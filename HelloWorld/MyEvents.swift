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
    private var state = "current"
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MyEventsController.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var btnCreatedEvent: UIBarButtonItem!
    @IBOutlet weak var btnFuturEvent: UIBarButtonItem!
    @IBOutlet weak var events_list: UITableView!
    @IBOutlet weak var btnPastEvent: UIBarButtonItem!
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCellMyEvents = events_list.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath as IndexPath) as! CustomCellMyEvents
        
        let str = String(describing: events[indexPath.row]["begin"])
        //let heure = str[str.startIndex.advancedBy(11)...str.startIndex.advancedBy(15)]
        var heure = ""
        var date = ""
        if events[indexPath.row]["begin"] != nil {
            date = str.transformToDate()
            let start = str.index(str.startIndex, offsetBy: 11)
            let end = str.index(str.endIndex, offsetBy: -3)
            let Range = start..<end
            heure = str.substring(with: Range)
            date += " à " + heure
        }

        cell.setCell(NameLabel: String(describing: events[indexPath.row]["title"]), imageName: String(describing: events[indexPath.row]["thumb_path"]), state: date)
        
        index += 1
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0,width: events_list.bounds.size.width, height: events_list.bounds.size.height))
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        
        if(events.count == 0 && state == "futur"){
            noDataLabel.text = "Vous n'avez aucun evenement prochainement"
        }else if(events.count == 0 && state == "current"){
            noDataLabel.text = "Vous n'avez aucun évènement en ce moment"
        }else if(events.count == 0 && state == "past"){
            noDataLabel.text = "Vous n'avez participer à aucun evenement"
        }
        else{
            noDataLabel.text = ""
        }
        events_list.backgroundView = noDataLabel
        
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        //        let dateFormatter = DateFormatter()
//        //        dateFormatter.dateFormat = "yyyy-MM-dd"
//        //        let date = dateFormatter.date(from: tabDate[section])
//        //        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
//        //        dateFormatter.dateStyle = DateFormatter.Style.full
//        //        let datefinale = dateFormatter.string(from: date!)
//        print("DATE Event : \(tabDate[section])")
//        return String(tabDate[section])?.transformToDate()
//        
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    
    func uniq<S: Sequence, E: Hashable>(source: S) -> [E] where E==S.Iterator.Element {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        btnFuturEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        events_list.tableFooterView = UIView()
        user = sharedInstance.volunteer["response"]
        events_list.addSubview(self.refreshControl)
        self.refresh()
        
    }
    
    
    func refresh() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        self.param["range"] = self.state
        print("STATE = "+state)
        let val = "volunteers/" + String(describing: user["id"]) + "/events"
        request.request(type: "GET", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.events = User["response"]
                self.events_list.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @IBAction func loadPastEvent(_ sender: AnyObject) {
        state = "past"
        btnPastEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        btnFuturEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        btnCreatedEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        self.refresh()
    }
    
    @IBAction func loadFuturEvent(_ sender: AnyObject) {
        state = "current"
        btnFuturEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        btnPastEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        btnCreatedEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        self.events = events_futur
        self.refresh()
    }
    @IBAction func loadCreatedEvent(_ sender: AnyObject) {
        state = "future"
        btnCreatedEvent.tintColor = UIColor(red: 111.0/255.0, green: 170.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        btnFuturEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        btnPastEvent.tintColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        self.refresh()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventProfilVC2"){
            let indexPath = events_list.indexPath(for: sender as! UITableViewCell)
            //            let currentCell = events_list.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            
            
            let secondViewController = segue.destination as! ProfilEventController
            
            secondViewController.EventID = String(describing: events[indexPath!.row]["id"])
            secondViewController.rights = String(describing: events[indexPath!.row]["rights"])
        }
    }
    
}
