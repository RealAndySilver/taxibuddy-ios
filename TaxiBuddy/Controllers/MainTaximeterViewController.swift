//
//  MainTaximeterViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 19/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit
import MapKit

class MainTaximeterViewController: UIViewController {
    
    enum PestanaViewType: Int {
        case RecargosPestana = 1
        case ServiceInfoPestana = 2
    }

    //Outlets 
    @IBOutlet weak var serviceInfoView: UIView!
    @IBOutlet weak var recargosView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startTaximeterButton: DesignableButton!
    @IBOutlet weak var minusButton: DesignableButton!
    @IBOutlet weak var plusButton: DesignableButton!
    @IBOutlet weak var taximeterUnitsButton: DesignableButton!
    
    //Varibles
    private var locationManager = CLLocationManager()
    private var taximeterIsOn = false
    private var initialPanningPoint: CGPoint!
    private var finalPanningPoint: CGPoint!
    private var middleRecargosViewPointX: CGFloat!
    private var middleServiceInfoViewPointX: CGFloat!
    private let kMaxDistanceToPanRecargosView: CGFloat = 190.0
    private let kMaxDistanceToPanServiceInfoView: CGFloat = 112.0
    private var recargosViewIsVisible = false
    private var serviceInfoViewIsVisible = false
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    //MARK: View lifecycle & Initialization stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        middleRecargosViewPointX = recargosView.frame.origin.x/2.0
        middleServiceInfoViewPointX = serviceInfoView.frame.origin.x/2.0
        setupMap()
    }
    
    private func setupMap() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("Decinicializando el main taximeter")
    }
    
    //MARK: Actions 
    
    @IBAction func tapDetected(sender: UITapGestureRecognizer) {
        let activeView: UIView!
        let activeViewIsVisible: Bool!
        let xMaxDistance: CGFloat!
        if sender.view!.tag == PestanaViewType.RecargosPestana.rawValue {
            activeView = recargosView
            activeViewIsVisible = recargosViewIsVisible
            xMaxDistance = kMaxDistanceToPanRecargosView
        } else {
            activeView = serviceInfoView
            activeViewIsVisible = serviceInfoViewIsVisible
            xMaxDistance = kMaxDistanceToPanServiceInfoView
        }
        
        if activeViewIsVisible == true {
            //Hidde the recargos view 
            UIView.animateWithDuration(0.4,
                delay: 0.0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.0,
                options: .CurveEaseOut,
                animations: { () -> Void in
                    activeView.transform = CGAffineTransformIdentity
                }, completion: { (succeded) -> Void in
                    if activeView.tag == PestanaViewType.RecargosPestana.rawValue {
                        self.recargosViewIsVisible = false
                    } else {
                        self.serviceInfoViewIsVisible = false
                    }
            })
        
        } else {
            //Show the recargos view details 
            UIView.animateWithDuration(0.4,
                delay: 0.0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.0,
                options: .CurveEaseOut,
                animations: { () -> Void in
                    activeView.transform = CGAffineTransformMakeTranslation(xMaxDistance, 0.0)
                }, completion: { (succeded) -> Void in
                    if activeView.tag == PestanaViewType.RecargosPestana.rawValue {
                        self.recargosViewIsVisible = true
                    } else {
                        self.serviceInfoViewIsVisible = true
                    }
            })
        }
    }
    
    @IBAction func panningDetected(sender: UIPanGestureRecognizer) {
        let activeView: UIView
        let middleViewPointX: CGFloat
        let kMaxDistanceToPanView: CGFloat
        
        if sender.view!.tag == PestanaViewType.RecargosPestana.rawValue {
            activeView = recargosView
            middleViewPointX = middleRecargosViewPointX
            kMaxDistanceToPanView = kMaxDistanceToPanRecargosView
        } else {
            activeView = serviceInfoView
            middleViewPointX = middleServiceInfoViewPointX
            kMaxDistanceToPanView = kMaxDistanceToPanServiceInfoView
        }
        
        if case .Began = sender.state {
             initialPanningPoint = sender.locationInView(view)
            
        
        } else if case .Changed = sender.state {
            finalPanningPoint = sender.locationInView(view)
            let deltaX = finalPanningPoint.x - initialPanningPoint.x
            activeView.transform = CGAffineTransformTranslate(activeView.transform, deltaX, 0.0)
            initialPanningPoint = finalPanningPoint
            //print("\(recargosView.frame.origin.x)")
        
        } else if case .Ended = sender.state {
            if activeView.frame.origin.x < middleViewPointX {
                //The user panned just a little, return the view to its original position
                UIView.animateWithDuration(0.4,
                    delay: 0.0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.0,
                    options: .CurveEaseOut,
                    animations: { () -> Void in
                        activeView.transform = CGAffineTransformIdentity
                    }, completion: { (succeded) -> Void in
                        if activeView.tag == PestanaViewType.RecargosPestana.rawValue {
                            self.recargosViewIsVisible = true
                        } else {
                            self.serviceInfoViewIsVisible = true
                        }
                })
            
            } else {
                //The user panned the require amount to show the recargos view details 
                UIView.animateWithDuration(0.4,
                    delay: 0.0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.0,
                    options: .CurveEaseOut,
                    animations: { () -> Void in
                        activeView.transform = CGAffineTransformMakeTranslation(kMaxDistanceToPanView, 0.0)
                    }, completion: { (succeded) -> Void in
                        if activeView.tag == PestanaViewType.RecargosPestana.rawValue {
                            self.recargosViewIsVisible = true
                        } else {
                            self.serviceInfoViewIsVisible = true
                        }
                })
            }
        }
    }
    
    @IBAction func startButtonPressed() {
        
        if !taximeterIsOn {
            //Start the taximeter process!
            startTaximeterButton.enabled = false
            startTaximeterButton.setImage(UIImage(assetIdentifier: .StopButton), forState: .Normal)
            
            //Animate the start button
            print("animareeeeeeeeee")
            //startTaximeterButton.animation = "morph"
            //startTaximeterButton.animate()
            
            //Change button color 
            UIView.animateWithDuration(0.3,
                animations: { () -> Void in
                    self.startTaximeterButton.backgroundColor = UIColor.getAppPrimaryColor()
                }, completion: { (succeded) -> Void in
                    self.startTaximeterButton.enabled = true
                    self.taximeterIsOn = true
            })
            
            //Show the taximeter units buttons 
            minusButton.delay = 0.2
            minusButton.animation = "squeezeDown"
            minusButton.x = -200.0
            minusButton.animate()
            
            taximeterUnitsButton.animation = "squeezeDown"
            taximeterUnitsButton.animate()
            
            plusButton.animation = "squeezeDown"
            plusButton.delay = 0.4
            plusButton.x = 200.0
            plusButton.animate()
            
        } else {
            //Stop the taximeter process!
            startTaximeterButton.enabled = false
            startTaximeterButton.setImage(UIImage(assetIdentifier: .StartButton), forState: .Normal)

            //Animate the start button
            print("animareeeeee")
            //startTaximeterButton.animation = "morph"
            //startTaximeterButton.animate()
            
            //Change the button color 
            UIView.animateWithDuration(0.3,
                animations: { () -> Void in
                    self.startTaximeterButton.backgroundColor = UIColor.getAppThirdColor()
                }, completion: { (succeded) -> Void in
                    self.startTaximeterButton.enabled = true
                    self.taximeterIsOn = false
            })
            
            //Hidde the taximeter buttons 
            minusButton.animation = "fadeOut"
            minusButton.x = -200.0
            minusButton.y = -200.0
            minusButton.animate()
            
            plusButton.animation = "fadeOut"
            plusButton.y = -200.0
            plusButton.x = 200.0
            plusButton.delay = 0.2
            plusButton.animate()
            
            taximeterUnitsButton.animation = "fadeOut"
            taximeterUnitsButton.y = -200.0
            taximeterUnitsButton.delay = 0.4
            taximeterUnitsButton.animate()
           
        }
    }
}

//MARK: CLLocationManagerDelegate 

extension MainTaximeterViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if case .AuthorizedAlways = status {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        guard let location = locations.last else {
            print("Could not get the last location")
            return
        }
        
        //Center the map on the user location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}
