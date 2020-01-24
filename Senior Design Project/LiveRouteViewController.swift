//
//  LiveRouteViewController.swift
//  Route Royale
//
//  Created by Steven Sanchez on 4/28/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit

class LiveRouteViewController: UIViewController {
    
    weak var masterViewController: MasterViewController?
    
    @IBOutlet weak var distanceTraveled: MetricsLabel!
    @IBOutlet weak var currentSpeed: MetricsLabel!
    @IBOutlet weak var completed: MetricsLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let masterVC = masterViewController {
            masterVC.speedChangedCallBack = { [weak self] newSpeed in
                self!.speed = newSpeed
            }
            masterVC.distanceChangedCallback = { [weak self] newDistance in
                self!.distance = newDistance
            }
        }
        
    }
    
    var distance: Double = 0 {
        didSet {
            let measurement = Measurement(value: distance, unit: UnitLength.meters)
            let formatter = MeasurementFormatter()
            formatter.unitStyle = .long
            formatter.numberFormatter.maximumFractionDigits = 2
            let distanceInMeters = formatter.string(from: measurement)
            
            distanceTraveled.mutableAttributedText = distanceInMeters
            
        }
    }
    
    var speed: Double = 0 {
        didSet {
            let measurement = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)
            let formatter = MeasurementFormatter()
            formatter.unitStyle = .short
            formatter.numberFormatter.maximumFractionDigits = 2
            let speedInMetesPerSec = formatter.string(from: measurement)
            currentSpeed.mutableAttributedText = speedInMetesPerSec
        }
    }
    
    var fractionCompleted = 0 {
        didSet {
            completed.mutableAttributedText = "\(fractionCompleted)"
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

