//
//  AppDelegate.swift
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
import SocketIO
import Foundation
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var socket: WebSocket!
    var locationManager: CLLocationManager!
    var currentLocation: (Float, Float) = (0.0, 0.0)
    var gameStateSTR: String = ""
    var json: JSON = []
    

    //--------------- Implementing WebSockets  ------------------
    func applicationDidBecomeActive(_ application: UIApplication) {
        socket = WebSocket(url: URL(string: "ws://sabretcnj.herokuapp.com/:42864")!, protocols: ["sabre"])
        socket.connect()

        socket.onConnect = {print("websocket is connected")}

        socket.onDisconnect = { (error: Error?) in print("websocket is disconnected:  (error?.localizedDescription)")}

        socket.onText = { (text: String) in  self.json = JSON(text)}

        socket.onData = { (data: Data) in print("got some data: \(data.count)")}
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    //-----------------------------------------------------------
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

