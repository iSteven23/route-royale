//
//  LocationCollectionViewController.swift
//  Route Royale
//
//  Created by Steven Sanchez on 4/21/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MetricsViewCell"

class LocationCollectionViewController: UICollectionViewController, MasterViewControllerDelegate {
    
    
    weak var masterViewController: MasterViewController?
    
    private var userRoute: Route? {
        return masterViewController!.currentRoute
    }
    private let routes = Routes.shared
    
    private var timerIsOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        masterViewController?.delegateLC = self
        // Register cell classes
        //self.collectionView!.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: cellID)

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func toggledTimer(_ timerOn: Bool) {
        timerIsOn = timerOn
        if(timerIsOn) {
            performSegue(withIdentifier: "CellsToLiveRoute", sender: nil)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? LiveRouteViewController {
            destination.masterViewController = masterViewController
        }
    }
 
    
    private func emptyMessage(_ message: String) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        self.collectionView.backgroundView = messageLabel
        return 0
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return routes?.count ?? 0 > 0 ? 1 : emptyMessage("You don't have any routes yet.\n Please create a route.")
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return routes?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RouteCollectionViewCell
        // Configure the cell
        let distance = routes![indexPath.row].distance
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.numberFormatter.maximumFractionDigits = 2
        let distanceInMeters = formatter.string(from: measurement)
        cell.distanceTraveledLabel.mutableAttributedText = distanceInMeters
        
        let time = Double(exactly: routes![indexPath.row].time) ?? 0.0
        let minutes = Int(time / 60) % 60
        let seconds = Int(time) % 60
        let measurementHours = Measurement(value: time, unit: UnitDuration.hours)
        let measurementMinutes = Measurement(value: Double(exactly: minutes) ?? 0.0, unit: UnitDuration.minutes)
        let measurementSeconds = Measurement(value: Double(exactly: seconds) ?? 0.0, unit: UnitDuration.seconds)

        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        let hoursString = formatter.string(from: measurementHours)
        let minutesString = formatter.string(from: measurementMinutes)
        let secondsString = formatter.string(from: measurementSeconds)
        
        print(secondsString)
        cell.finishedTime.mutableAttributedText = secondsString
        cell.fractionCompleted.mutableAttributedText = "\(routes![indexPath.row].userCompleted)"
        
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
