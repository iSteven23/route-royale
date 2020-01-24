//
//  MasterViewController.swift
//  Route Royale
//
//  Created by Steven Sanchez on 4/21/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var sideMenuStackView: UIStackView!
    @IBOutlet weak var drawer: UIView!
    @IBAction func toggleDrawerTapped() {
        setUpAnimation()
        animator.startAnimation()

    }
    var isDrawerOpen = false
    var drawerPanStart: CGFloat = 0
    var animator: UIViewPropertyAnimator!
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var delegateMC: MasterViewControllerDelegate?
    var delegateLC: MasterViewControllerDelegate?
    
    lazy var currentRoute: Route = Route()
    
    @IBOutlet weak var TimerDisplay: UILabel!

    private(set) var runningTime = Timer()
    private(set) var timerRunning = false
    
    
    var speedChangedCallBack: ((Double) -> ())?
    var distanceChangedCallback: ((Double) -> ())?
    
    var seconds = 0 {
        didSet {
            if timerRunning {
                TimerDisplay.text = String(format: "%02i:%02i:%02i", seconds/3600, seconds/60 % 60, seconds % 60)
                
            }
            else {
                TimerDisplay.text = "--:--"
            }
        }
    }
    
    func speedDidChange() {
        speedChangedCallBack!(currentRoute.speed)
    }
    
    func distanceDidChange() {
        let distance = currentRoute.distance
        distanceChangedCallback!(distance)
        
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            print("Logout Successful")
            dismiss(animated: true, completion: nil)
        }
        catch{
            print("Issue logging out")
        }
        
    }
    
    @IBAction func toggleTimerButton(_ sender: UIButton) {
        timerRunning = !timerRunning
        //will set current route
        delegateMC!.toggledTimer(timerRunning)
        delegateLC!.toggledTimer(timerRunning)
        if(timerRunning) {
            //DeviceStorage.clear(.documents)
            runningTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.seconds = self.seconds + 1
            }
            sender.setAttributedTitle(NSAttributedString(string: "▫️"), for: .normal)
        }
        else {
            sender.setAttributedTitle(NSAttributedString(string: "+"), for: .normal)
            runningTime.invalidate()
            currentRoute.time = seconds
            seconds = 0
        }
        
        
    }
    
    func seguetoRouteDetail() {
        performSegue(withIdentifier: "MaintoRouteDetail", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("master view did appear")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // makes navigation bar completely transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        
        
        sideMenuLeadingConstraint.constant -= sideMenuView.frame.width
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanOnDrawer(recognizer:)))
        drawer.addGestureRecognizer(panRecognizer)
    }
    
    
    @objc func didPanOnDrawer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            setUpAnimation()
            animator.pauseAnimation()
            drawerPanStart = animator.fractionComplete
        case .changed:
            if self.isDrawerOpen {
                animator.fractionComplete = (recognizer.translation(in: drawer).y / 305) + drawerPanStart
            }
            else {
                animator.fractionComplete = (recognizer.translation(in: drawer).y / -305) + drawerPanStart
            }
        default:
            drawerPanStart = 0
            let timing = UICubicTimingParameters(animationCurve: .easeOut)
            animator.continueAnimation(withTimingParameters: timing, durationFactor: 0)
        }
    }
    
    func setUpAnimation() {
        guard animator == nil || animator.isRunning == false else { return }
        
        animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut) { [unowned self] in
            if self.isDrawerOpen {
                self.drawer.transform = CGAffineTransform.identity
            }
            else {
                self.drawer.transform = CGAffineTransform(translationX: 0, y: -305)
            }
        }
        animator.addCompletion { [unowned self] _ in
            self.animator = nil
            self.isDrawerOpen = !(self.drawer.transform == CGAffineTransform.identity)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape{
            sideMenuStackView.spacing = 1
        }
        else{
            sideMenuStackView.spacing = 40
            print("Spacing: ", sideMenuStackView.spacing)
        }
    }
    
    
    
    var isSideMenuOpen:Bool = false
    
    @IBAction func sideMenuButton(_ sender: UIBarButtonItem) {
        
        sideMenuOpen()
    }
    
    func sideMenuOpen()
    {
        isSideMenuOpen = !isSideMenuOpen
        if(isSideMenuOpen)
        {
            sideMenuLeadingConstraint.constant += sideMenuView.frame.width
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        }
        else{
            
            sideMenuLeadingConstraint.constant -= sideMenuView.frame.width
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
            
        }
        
    }
    
    @IBAction func sideMenuLeftGestureSwipe(_ sender: UISwipeGestureRecognizer) {
        sideMenuOpen()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        let identifier = segue.identifier
        switch identifier {
        case "RouteCollection":
            if let nvc = destination as? UINavigationController, let locationController = nvc.viewControllers.first as? LocationCollectionViewController {
                locationController.masterViewController = self
            }
        case "MapViewRoutes":
            if let mapController = destination as? MapViewController {
                mapController.masterViewController = self
            }
        case "MaintoRouteDetail":
            if let maintoRouteVC = destination as? RouteDetailViewController {
                maintoRouteVC.route = currentRoute
            }
        default:
            print("Other segue triggered")
        }
        
     
     }
    

}


