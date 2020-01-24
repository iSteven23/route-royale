//
//  LogInViewController.swift
//  Senior Design Project
//
//  Created by Steven Sanchez on 11/27/18.
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var signInReg: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    var ref:DatabaseReference?
    
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    //Checking if user is logged in. if yes then jump straight to main menu scene
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "goToMap", sender: self)        }
    }
    
    @IBAction func signInRegChanged(_ sender: Any) {
        
        isSignIn = !isSignIn
        
        if isSignIn{
            //signInLabel.text = "Sign In"
            userNameTextField.isHidden = true
            signInButton.setTitle("Sign In", for: .normal)
        }
        else{
            //signInLabel.text = "Register"
            userNameTextField.isHidden = false
            signInButton.setTitle("Register", for: .normal)
            
        }
    
    }
    
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        //TODO: validate email and password
        
        if let email = emailTextField.text, let pass = passwordTextField.text{
            
            if isSignIn{
                //sign in firebase
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    if let u = user{
                        // user found go to main menu
                        self.resetTextField()
                        self.performSegue(withIdentifier: "goToMap", sender: self)
                        print("User: ", u)
                    }
                    else{
                        // check error and show message
                        self.signInLabel.text = "Wrong email and/or password entered"
                        
                    }
                }
            }
            else{
                //register with firebase
                Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                    
                    //check user is not null
                    if let u = user{
                        // user is found go to main menu
                        print("User: ", u)
                        
                        let userName = self.userNameTextField.text
                        let currentUser = Auth.auth().currentUser
                        let uid = currentUser?.uid
                        
                        self.ref = Database.database().reference()
                        
                        self.ref?.child("Users").child(uid!).setValue(["Username": userName])
                        
                        self.resetTextField()
                        
                        self.performSegue(withIdentifier: "goToMap", sender: self)
                    }
                    else{
                        //Error: check error and show message
                        self.signInLabel.text = "Invalid email entered"
                        
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismisses keyboard on view tap
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func resetTextField()
    {
        emailTextField.text = ""
        passwordTextField.text = ""
        userNameTextField.text = ""
        signInLabel.text = ""
    }
    
}
