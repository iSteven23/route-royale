//
//  ViewController.swift
//  Senior Design Project
//
//  Created by Aaron on 10/9/18.
//  Contributors: Steven Sanchez, Mike Maldonado
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import os.log


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, MasterViewControllerDelegate {
    
    private lazy var userRoute: Route = masterViewController!.currentRoute

    weak var masterViewController: MasterViewController?
    var manager: CLLocationManager
    var timerOn = false
    //var userLocations = [UserLocations]()
    var lastUserLocation: CLLocation?
    var locationsToRender = [CLLocationCoordinate2D]()
    var aPolyline = MKPolyline()
    var lastUserLocationIndex = -1
    private var arcDistance: Double = 0.0
    @IBOutlet weak var mapView: MKMapView!

    required init?(coder aDecoder: NSCoder) {
        manager = LocationManager.shared
        manager.requestAlwaysAuthorization()
        super.init(coder: aDecoder)
        manager.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // removes line at bottom of navigation bar
        let rts = DeviceStorage.retrieve("userRoutes.txt", from: DeviceStorage.Directory.documents, as: [Route].self)
        if let rts = rts {
            Routes.shared!.append(contentsOf: rts)
        }
        masterViewController!.delegateMC = self

    }
    
    
    //let concurrentLocationQueue = DispatchQueue(label: "com.RouteRoyal.locationQueue", attributes: .concurrent)
    func toggledTimer(_ masterTimer: Bool) {
        //value is recieved before being toggled
        timerOn = masterTimer
        locationsToRender.removeAll()

        mapView.removeOverlay(aPolyline)
        if(!timerOn) {
            //addAnnotation()
            manager.stopUpdatingLocation()
            let alert = UIAlertController(title: "Route Ended", message: "Did you finish your route?", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self](alert) -> Void in
                self!.userRoute.userCompleted = 100
                self!.masterViewController!.seguetoRouteDetail()
                }))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
     private func addAllAnnotations() {
        let allRoutes = Routes.shared
        if let routes = allRoutes, routes.count > 0 {
            
            routes.forEach {
                let annotation = MKPointAnnotation()
                if let startPoint = $0.userLocations.first {
                    let mypoint = CLLocationCoordinate2D(latitude: startPoint.latitude, longitude: startPoint.longitude)
                    annotation.title = $0.routeName
                    annotation.coordinate = mypoint
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        if let startPoint = userRoute.userLocations.first {
            let mypoint = CLLocationCoordinate2D(latitude: startPoint.latitude, longitude: startPoint.longitude)
            annotation.title = userRoute.routeName
            annotation.coordinate = mypoint
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear")
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            //manager.distanceFilter = 10.0
            manager.requestAlwaysAuthorization()
            manager.activityType = CLActivityType.fitness
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        }
        
        addAllAnnotations()

    }
        
    
    
    func alertLocationAccessNeeded() {
        let settingAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(title: "Need Location Access", message: "Location access is required for this app", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Location Access", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingAppURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //send update location to be displayed
        displayLocation(from: locations)
        //only take most recent location for storing
        let recentLocation = locations.last!
        if timerOn {
            //save less data
            if lastUserLocation == nil || recentLocation.distance(from: lastUserLocation ?? recentLocation) > 1 {
                updateLocation(with: recentLocation)
                lastUserLocation = recentLocation
                lastUserLocationIndex += 1
            }
            else if lastUserLocationIndex != -1 {
                //only update timestamp && cordinates
                userRoute.userLocations[lastUserLocationIndex].latitude = recentLocation.coordinate.latitude
                userRoute.userLocations[lastUserLocationIndex].longitude = recentLocation.coordinate.longitude
                userRoute.time = masterViewController!.seconds
            }
            createPolyline(with: recentLocation)
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if(overlay is MKPolyline) {
            
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.fillColor = UIColor.blue
            polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
            polylineRender.lineWidth = 5
            return polylineRender
        }
        return MKPolylineRenderer()
        
    }
    
    private func createPolyline(with recentLocation: CLLocation) {
        if(self.userRoute.userLocations.count > 0) {

            let newEndpoint = self.userRoute.userLocations.last
            self.locationsToRender += [CLLocationCoordinate2DMake(newEndpoint!.latitude, newEndpoint!.longitude)]
            aPolyline = MKPolyline(coordinates: self.locationsToRender, count: self.locationsToRender.count)
            self.mapView.addOverlay(aPolyline)
        }
        
    }
    
    
    //centers location parameter on the map view
    func displayLocation(from locations: [CLLocation]) {
        let location = locations.last!
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: myLocation, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    private func updateLocation(with location: CLLocation?) {
        if let currentLocation = location {
            //read
            let recentLoc = UserLocations(longitude: currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude, time: self.masterViewController!.seconds )
            userRoute.speed = location!.speed.magnitude
            userRoute.distance += location?.distance(from: lastUserLocation ?? currentLocation) ?? 0
            self.userRoute.userLocations += [recentLoc]
            if userRoute.speed != lastUserLocation?.speed {
                masterViewController?.speedDidChange()
            }
            masterViewController?.distanceDidChange()
            
        }
        
    }
    
    private func storeRoutes() {
        //write
        DispatchQueue.global(qos: .background).async { [weak self] in
            var routes = Routes.shared!
            routes.append(self!.userRoute)
            DeviceStorage.store(routes, to: .documents, as: "userRoutes.txt")
            self!.userRoute.userLocations.removeAll()
            self!.lastUserLocationIndex = -1
            DispatchQueue.main.async { [weak self] in
                //TODO: SAVE POPUP
                let alert = UIAlertController(title: "Route Saved", message: "Route was saved", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self!.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.manager.startUpdatingLocation()
            }
        case .restricted, .denied:
            self.alertLocationAccessNeeded()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Update error: \(error.localizedDescription)")
    }

    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}


