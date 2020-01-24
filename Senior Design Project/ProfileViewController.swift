//
//  ProfileViewController.swift
//  Senior Design Project
//
//  Created by Steven Sanchez on 12/4/18.
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Foundation

class ProfileViewController: UIViewController {
    
    var ref:DatabaseReference?
    
    var friendUidArray:[String] = []
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the storage service using the default Firebase App
        //let storage = 
        
        // Create a storage reference from our storage service
        let storageRef = Storage.storage()
        
        //let store = StorageReference()

        ref = Database.database().reference(fromURL: "https://seniordesignproject-95d38.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        ref?.child("Users").child(userID!).child("Username").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            let value = snapshot.value as? String
            self.usernameLabel.text = value
        })
        
        
        /*ref?.child("Users").child(userID!).child("Friends").observe(.value, with: {(snapshot) in
            print(snapshot.childrenCount)
            
            if snapshot.childrenCount > 0
            {
                for i in 0 ... snapshot.childrenCount - 1
                {
                self.ref?.child("Users").child(userID!).child("Friends").child(String(i)).observeSingleEvent(of: .value, with: {(snapshot) in
                    let id = snapshot.value as? String
                    self.friendUidArray.append(id!)
                    //print(self.friendUid)
                })
                }
            }
        })*/
        

        // Do any additional setup after loading the view.
    }
    let index = 0
    
    let longitudeArray = [1110, 1010, 1111, 1011, 1001]
    let latitudeArray = [6969, 6906, 6069, 6069, 1969]
    var routeNumber:Int = 0
    
    let currentUser = Auth.auth().currentUser
    
    @IBAction func AddRandomNumButtonPressed(_ sender: UIButton) {
        print("Added route \(routeNumber) to firebase")
        
        //let currentUser = Auth.auth().currentUser
        let uid = currentUser?.uid
        
        self.ref = Database.database().reference()
        
        self.ref?.child("Users").child(uid!).child("Routes").child("Route \(self.routeNumber)").child("Longitude").setValue(longitudeArray)
        
        self.ref?.child("Users").child(uid!).child("Routes").child("Route \(self.routeNumber)").child("Latitude").setValue(latitudeArray)
        
        self.routeNumber = self.routeNumber + 1
        
        }
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    
    @IBAction func sendRouteButton(_ sender: UIButton) {
        
        
        
        if let userNameSearch = userNameTextField.text{
            print(userNameSearch)
            
        }
        
        if let uid = self.currentUser?.uid
        {
            self.ref?.child("Users").child(uid).child("Friends").observeSingleEvent(of: .value, with: {(snapshot) in
                //let id = snapshot.value as? String
                //self.friendUidArray.append(id!)
                //i = i + 1
                var arrString:String = ""
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    let value = snap.value
                    
                    arrString = "\(arrString) \(String(describing: value!))"
                    self.friendUidArray = arrString.components(separatedBy: " ")
                    
                    if self.friendUidArray[0] == ""{
                        self.friendUidArray.removeFirst()
                    }
                    
                    print(" Friends list: ", self.friendUidArray)
                    
                }
                
            })
            
        }
        
        ref?.child("Users").queryOrdered(byChild: "Username").queryEqual(toValue: userNameTextField.text).observeSingleEvent(of: .childAdded, with: {(Snapshot) in
            //print(Snapshot.key)
            
            var matchFound = false
            for match in self.friendUidArray
            {
                if match == Snapshot.key
                {
                    matchFound = true
                    break
                }
                
            }
            if matchFound == false
            {
                self.friendUidArray.append(Snapshot.key)
            
                if let uid = self.currentUser?.uid
                {
                    //self.ref?.child("Users").child(uid).updateChildValues(["Friends": self.friendUidArray])
                    self.ref?.child("Users").child(uid).child("Friends").setValue(self.friendUidArray)
                
                }
            }
            
        })
        
    }
    
    
    
    
    @IBAction func backToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
