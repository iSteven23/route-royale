//
//  sideMenuTableViewController.swift
//  Route Royale
//
//  Created by Steven Sanchez on 2/11/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit
import FirebaseAuth

var myIndex = 0

class sideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex = indexPath.row
        print(myIndex)
        
        if(myIndex == 5)
        {
            do{
                try Auth.auth().signOut()
                print("Logout Successful")
                dismiss(animated: true, completion: nil)
            }
            catch{
                print("Issue logging out")
            }
        }
        
    }

}
