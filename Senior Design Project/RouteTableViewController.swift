//
//  RouteTableViewController.swift
//  Route Royale
//
//  Created by Aaron Dahlin on 2/25/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit
import os.log

class RouteTableViewController: UITableViewController {
    
    //MARK: Properties
    var routes = [Route]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let loadedroutes = Routes.shared else {
            os_log("Unable to load routes from archive", log: OSLog.default, type: .debug)
            return
        }
        routes = loadedroutes
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "RouteCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RouteCell else {
            fatalError("The dequeued cell is not an instance of RouteCell.")
        }
        
        let route = routes[indexPath.row]
        
        cell.nameLabel.text = route.routeName
        cell.distanceLabel.text = "Distance: \(route.distance)"
        cell.timeLabel.text = "Time: \(route.time.description)"
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let routeDetailViewController = segue.destination as? RouteDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedRouteCell = sender as? RouteCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedRouteCell) else {
            fatalError("The selected cell is not being displayed by the table.")
        }
        
        let selectedRoute = routes[indexPath.row]
        routeDetailViewController.route = selectedRoute
        routeDetailViewController.index = indexPath.row
    }
 

}
