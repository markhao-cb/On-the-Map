//
//  ListTableViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class ListTableViewController: OTMNavigationViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TODO: need to get from API
    var locations = Utilities.appDelegate.hardCodedLocationData()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListTableViewCell") as! ListTableViewCell
        
        return cell
    }

}
