//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by paul on 14/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var network: NetworkService?
    var storage: StorageService?
    var location: LocationManager?
    var imageProvider: ImageProvider?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        location = LocationManager()
        network = OnlineNetworking()
        storage = CoreData.shared
        imageProvider = OnlineNetworking()
        
        return true
    }

}
