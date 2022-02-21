//
//  LocationManager.swift
//  iOS-Natif
//
//  Created by Earth on 20.02.2022.
//

import Foundation
import CoreLocation

class LocationManager {
    
    private static var locationManager = CLLocationManager()
        
    static func locationManagerSettings() {
        if CLLocationManager.locationServicesEnabled() == true {
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Enabling the Location Services switch in Settings > Privacy.")
            fatalError()
        }
    }
    
    static func set(delegate: CLLocationManagerDelegate) {
        self.locationManager.delegate = delegate
    }
    
    static func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    static func getCoordinate() -> CLLocationCoordinate2D? {
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return nil }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        return locValue
    }
    
    private init() {}
}
