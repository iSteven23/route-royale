//
//  MenuViewController.swift
//  Senior Design Project
//
//  Created by Mike Maldonado on 11/17/18.
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // removes line at bottom of navigation bar
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // makes navigation bar completely transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            print("Logout Successful")
            dismiss(animated: true, completion: nil)
        }
        catch{
            print("Issue logging out")
        }
    }
    
    /*
     x
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

