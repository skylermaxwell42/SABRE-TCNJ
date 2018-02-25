//
//  ViewController.swift
//  SABRE-TCNJ
//
//  Created by Skyler Maxwell on 2/24/18.
//  Copyright © 2018 TCNJ IMPL. All rights reserved.
//

import UIKit
import Starscream
import MapKit
import CoreLocation
import CoreGraphics

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    

    let app_del = UIApplication.shared.delegate as! AppDelegate
    
    //  ----------------------- Class Properties ----------------------------------
    
    var locationManager: CLLocationManager!
    var currentLocation: (Float, Float) = (0.0, 0.0)
    var enemyLocation: (Float, Float) = (0.0, 0.0)
    var gameStateJSON: String = ""
    var gameTimer: Timer!
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    struct UserData: Encodable {
        let userName: String?
        let latitude: String?
        let longitude: String?
    }
    
    //  ----------------------- User Interaction --------------------------
    @IBOutlet weak var userName: UITextField!
    
    
    //  ----------------------- Send Data to Server -----------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let userStartData = UserData(userName: userName.text!, latitude: String(currentLocation.0), longitude: String(currentLocation.1))
        //  "try!" is not good practice but OK for now
        let userStartJSON = try! encoder.encode(userStartData)
        let userStartComsToServer = String(data: userStartJSON, encoding: .utf8)
        app_del.socket.write(string: userStartComsToServer!)
        print(userName.text!)
        
        performSegue(withIdentifier: "toMainView", sender: self)

        return true
    }
    
    func sendGPSToServer(location: CLLocation!) {
        let userStartData = UserData(userName: userName.text!, latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
        let userStartJSON = try! encoder.encode(userStartData)
        let userStartComsToServer = String(data: userStartJSON, encoding: .utf8)
        app_del.socket.write(string: userStartComsToServer!)
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

        userName.delegate = self
        
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
        
        //  Setting up MapView for ViewController
        splashMap.delegate = self
        splashMap.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let latDelta:CLLocationDegrees = 0.1
        let lonDelta:CLLocationDegrees = 0.1
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(currentLocation.0), CLLocationDegrees(currentLocation.1))
        let region = MKCoordinateRegionMake(location, span)
        splashMap.setRegion(region, animated: true)

        //gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateGameState), userInfo: nil, repeats: true)
        
        gameStateJSON = "{player 1,0.0,0.0,20,0.5,1,2,2.0,1}"
    
    }
   
    @IBOutlet weak var splashMap: MKMapView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

