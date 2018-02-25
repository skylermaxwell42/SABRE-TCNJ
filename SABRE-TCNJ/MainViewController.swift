//
//  MainViewController.swift
//  
//
//  Created by Brandon Siebert on 2/25/18.
//

import UIKit
import Starscream
import MapKit
import CoreLocation
import CoreGraphics
import SwiftyJSON

class MainViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let app_del = UIApplication.shared.delegate as! AppDelegate
    
    //  ----------------------- Class Properties ----------------------------------
    var locationManager: CLLocationManager!
    var currentLocation: (Float, Float) = (0.0, 0.0)
    var enemyLocation: (Float, Float) = (0.0, 0.0)
    var gameStateDict = [String: String]()
    var gameTimer: Timer!
    var jsonData: Data?
    var error: NSError?
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    struct UserData: Codable {
        let userName: String?
        let latitude: String?
        let longitude: String?
    }
    struct positionState: Codable {
        let userName: String?
        let latitude: Float?
        let longitude: Float?
        let amount: Int?
        let moveSpeed: Float?
        let defense: Int?
        let attack: Int?
        let generate: Int?
    }
    struct moveCluster: Codable {
        let id: Int?                    //  Index of Object Array
        let amount: Int?
        let from: [Float?]
        let to: [Float?]
        let first: Bool?
    }
    
    let arrPins: [MKPointAnnotation] = []
    
    //  ----------------------- Place Pins --------------------------------
    
    func placePin(coordinates: (Float, Float), title: String) {
        let newLoc = CLLocationCoordinate2DMake(CLLocationDegrees(coordinates.0), CLLocationDegrees(coordinates.1))
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newLoc
        dropPin.title = title
        let mePin = MKPointAnnotation()
        mePin.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(currentLocation.0), CLLocationDegrees(currentLocation.1))
        mePin.title = "You"
        splashMap.addAnnotation(dropPin)
        splashMap.addAnnotation(mePin)
        let arrPins = [dropPin, mePin]
    
        
        
    }
    
    func plotPins(arrPins: [MKPointAnnotation]) {
        splashMap.showAnnotations(arrPins, animated: true)
    }
    
    func digestData(data: positionState) {
    }
    
    
 
    func sendGPSToServer(location: CLLocation!) {
        //let userStartComsToServer = String(data: userStartJSON, encoding: .utf8)
        //socket.write(string: userStartComsToServer!)
    }
    
    //  ---------------------- Recieve Data From Server ---------------------
    @objc func updateGameState() {
        sendGPSToServer(location: locationManager.location)
    }
    
    
    //  ----------------------- MapKit Initialization ------------------------
    func getLocation(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        currentLocation  = (Float(newLocation.coordinate.latitude),Float(newLocation.coordinate.longitude))
        print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        
    }
    
    //  ---------------------- View Controller Init ---------------------------
    override func viewDidLoad() {
        
        //  Setting up websockets
        super.viewDidLoad()
        
        //  Setting up MapKit
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
        let status = CLLocationManager.authorizationStatus()
        if (status == .notDetermined || status == .denied || status == .authorizedWhenInUse) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        getLocation(manager: locationManager!, didUpdateToLocation: locationManager.location!, fromLocation: locationManager.location!)
        
        //  Setting up MapView
        
        splashMap.delegate = self
        splashMap.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let latDelta:CLLocationDegrees = 0.1
        let lonDelta:CLLocationDegrees = 0.1
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(currentLocation.0), CLLocationDegrees(currentLocation.1))
        let region = MKCoordinateRegionMake(location, span)
        splashMap.setRegion(region, animated: true)
        
        //gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateGameState), userInfo: nil, repeats: true)
        
        //let gameStateJSON = "{player 1,0.0,0.0,20,0.5,1,2,2.0,1}"
        
        
        placePin(coordinates: (currentLocation.0 + Float(0.00096), currentLocation.1 + Float(0.00096)), title: "Enemy")
        placePin(coordinates: (currentLocation.0 - Float(0.00096), currentLocation.1 + Float(0.00096)), title: "Base 1")
        placePin(coordinates: (currentLocation.0 - Float(0.00096), currentLocation.1 - Float(0.00096)), title: "Base 2")
        placePin(coordinates: (currentLocation.0 + Float(0.00096), currentLocation.1 - Float(0.00096)), title: "Base 3")
        placePin(coordinates: (currentLocation.0 - Float(0.001), currentLocation.1 + Float(0.001)), title: "Base 4")
        placePin(coordinates: (currentLocation.0 + Float(0.001), currentLocation.1 + Float(0.001)), title: "Base 5")
        
        
    }
    
    @IBOutlet weak var splashMap: MKMapView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
