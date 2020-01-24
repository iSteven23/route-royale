//
//  ForgotPasswordViewController.swift
//  Route Royale
//
//  Created by Steven Sanchez on 4/3/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        
        let emailAddress = emailTextField.text
        
        Auth.auth().sendPasswordReset(withEmail: emailAddress!) { error in
            // ...
        }
        
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
