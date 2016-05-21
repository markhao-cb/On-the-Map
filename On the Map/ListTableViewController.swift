//
//  ListTableViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class ListTableViewController: OTMNavigationViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(locationDataUpdated), name: Utilities.NotificationConstants.LocaltionDataUpdated, object: nil)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = locations {
            return locations.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListTableViewCell") as! ListTableViewCell
        
//        let location = locations![indexPath.row]
//        
//        let first = location["firstName"] as! String
//        let last = location["lastName"] as! String
//        let mediaURL = location["mediaURL"] as! String
        
        
//        cell.listNameLabel.text = "\(first) \(last)"
        return cell
    }
    
    func locationDataUpdated() {
        performUIUpdatesOnMain { 
            self.listTableView.reloadData()
        }
    }

}
