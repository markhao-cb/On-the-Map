//
//  ListTableViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import JCAlertView

class ListTableViewController: OTMNavigationViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(locationDataUpdated), name: Utilities.NotificationConstants.LocaltionDataUpdated, object: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListTableViewCell") as! ListTableViewCell
        let location = locations[indexPath.row]
        cell.listNameLabel.text = "\(location.firstName) \(location.lastName)"
        return cell
    }
    
    func locationDataUpdated() {
        performUIUpdatesOnMain { 
            self.listTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = locations[indexPath.row]
        openUrlFrom(location.mediaURL)
    }
}
