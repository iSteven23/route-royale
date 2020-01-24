//
//  RouteDetailViewController.swift
//  Route Royale
//
//  Created by Aaron Dahlin on 3/10/19.
//  Copyright © 2019 Aaron Dahlin. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    
    //Variables for editing route list and saving. Couldn't think of an easier way
    //These get defined when a route is selected in the tableview
    var index = Routes.shared?.count ?? 1 - 1
    //var callback: (() -> ())?
    var route = Route()
    let aPolyline = MKPolyline()
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        descriptionField.delegate = self
        mapView.delegate = self
        
        nameField.text = route.routeName
        distanceLabel.text = "Distance: \(route.distance)"
        timeLabel.text = "Time: \(route.time)"
        if route.rdescription != nil{
            print("Route description is " + route.rdescription!)
            descriptionField.text = route.rdescription
        } else { print("Route description is currently nil") }
        
        loadMap()
        
    }
    
    func loadMap(){
        /*guard let route = route else {
            fatalError("Failed to load route, found nil value")
        }*/
        print("Number of points in route: \(route.userLocations.count)")
        /*guard route.coordinates.last != nil else {
            fatalError("Failed to load last point, found nil value")
        }
        //Configure map to display route, centered on middle point
        let centerIndex = route.coordinates.count/2
        let center = CLLocationCoordinate2DMake(route.coordinates[centerIndex].latitude, route.coordinates[centerIndex].longitude)
         */
        guard route.userLocations.last != nil else {
            fatalError("Failed to load last point, found nil value")
        }
        
        let locationsToRender = route.userLocations.map { (location) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        let aPolyline = MKPolyline(coordinates: locationsToRender, count: locationsToRender.count)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: aPolyline.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(aPolyline)
        print("End of loadMap function")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.fillColor = UIColor.blue
        polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polylineRender.lineWidth = 5
        return polylineRender
        
    }
    
    //MARK: Text Field methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Distinguish between title and description textfield
        if textField == nameField {
            route.routeName = textField.text!
        }
        if textField == descriptionField{
            route.rdescription = textField.text
            print("edited description to " + route.rdescription!)
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc func doneEditing() {
        //Update list of routes with new information and save
        route.routeName = nameField.text!
        route.rdescription = descriptionField.text
        var routes = Routes.shared
        routes!.insert(route, at: index)
        DeviceStorage.store(routes, to: .documents, as: "userRoutes.txt")
        navigationController?.popViewController(animated: true)
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
