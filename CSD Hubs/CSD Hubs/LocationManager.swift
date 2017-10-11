//
//  LocationManager.swift
//  Whiz CRM
//
//  Created by Manish on 29/09/17.
//  Copyright © 2017 Manish Sharma. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

public class LocationManager:NSObject,CLLocationManagerDelegate  {
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    public static  let sharedLocationManager = LocationManager()
    
    public  var currentLocation:CLLocation? = CLLocation(latitude:CLLocationDegrees(18.5158), longitude: CLLocationDegrees(73.909))
    
    
    public  func instantiate() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        currentLocation = userLocation
        
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
}
