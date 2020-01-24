//
//  sideMenuViewController.swift
//  Route Royale
//
//  Created by Steven Sanchez on 2/11/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit
import FirebaseAuth

class sideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sideMenuButtonPressed(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            print("Logout Successful")
            dismiss(animated: true, completion: nil)
        }
        catch{
            print("Issue logging out")
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
