//
//  CalculateRouteViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 21/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit
import MapKit

class CalculateRouteViewController: UIViewController {

    //enums
    enum CurrentSelectedRoutePoint: Int {
        case BeginPoint = 0
        case FinalPoint
    }
    
    //Outlets 
    @IBOutlet weak var routeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var calculateBottomView: DesignableView!
    
    //Private variables 
    private var currentSelectedRoutePoint = CurrentSelectedRoutePoint.BeginPoint
    private let locationManager = CLLocationManager()
    private var firstTimeViewAppears = true
    private var beginPointAnnotation = MyAnnotation(categoryId: 0)
    private var finalPointAnnotation = MyAnnotation(categoryId: 1)
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    //MARK: View lifecycle & Initialization Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentSelectedRoutePoint = CurrentSelectedRoutePoint(rawValue: routeSegmentedControl.selectedSegmentIndex)!
        setupMap()
    }
    
    private func setupMap() {
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            //The user has not authorized the app to get the location
            locationManager.requestAlwaysAuthorization()
        } else {
            //We have location authorization, center the map on the user location
            locationManager.startUpdatingLocation()
        }
        locationManager.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstTimeViewAppears {
            calculateBottomView.animate()
            firstTimeViewAppears = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("Deinicializando el calculandoRouteVC")
    }
    
    //MARK: Actions 
    
    @IBAction func calculateButtonPressed() {
        //Calculate only if the user has selected the initial and final route points 
        if beginPointAnnotation.setOnMap && finalPointAnnotation.setOnMap {
            let resultsVC = storyboard?.instantiateViewControllerWithIdentifier("ResultsOfCalculateRoute") as! ResultsOfCalculateRouteViewController
            resultsVC.modalTransitionStyle = .CrossDissolve
            resultsVC.modalPresentationStyle = .OverCurrentContext
            presentViewController(resultsVC, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "", message: "No has elegido ambos puntos en el mapa", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func mapTapped(sender: UITapGestureRecognizer) {
        //Get touch location in Map Coordinates
        let touchLocation = sender.locationInView(mapView)
        let coordinates = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
        
        let selectedAnnotation: MyAnnotation
        
        switch currentSelectedRoutePoint {
        case .BeginPoint:
            print("We are selecting the begin point")
            selectedAnnotation = beginPointAnnotation
            selectedAnnotation.title = "Punto de Salida"
            
        case .FinalPoint:
            print("We are selecting the final point")
            selectedAnnotation = finalPointAnnotation
            selectedAnnotation.title = "Punto de Llegada"
        }
        
        //Remove the current annotation
        mapView.removeAnnotation(selectedAnnotation)
        
        //Draw pin
        selectedAnnotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        selectedAnnotation.setOnMap = true
        mapView.addAnnotation(selectedAnnotation)
    }
    
    @IBAction func routeSegmentControlPressed(sender: UISegmentedControl) {
        currentSelectedRoutePoint = CurrentSelectedRoutePoint(rawValue: sender.selectedSegmentIndex)!
    }
}

//MARK: CLLocationManagerDelegate 

extension CalculateRouteViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let lastLocation = locations.last else {
            print("Error obteniendo la locación")
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        let centerRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(centerRegion, animated: true)
    }
}

//MARK: MKMapViewDelegate

extension CalculateRouteViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MyAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            let myAnnotation = annotation as! MyAnnotation
            if myAnnotation.categoryId == CurrentSelectedRoutePoint.BeginPoint.rawValue {
                pinView.pinColor = MKPinAnnotationColor.Green
            } else if myAnnotation.categoryId == CurrentSelectedRoutePoint.FinalPoint.rawValue {
                pinView.pinColor = MKPinAnnotationColor.Purple
            }
            return pinView
        } else {
            return nil
        }
    }
}
