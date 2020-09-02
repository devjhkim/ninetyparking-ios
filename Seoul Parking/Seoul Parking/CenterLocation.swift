//
//  CenterLocation.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/25/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class CenterLocation: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    @Published var location = CLLocation()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension CenterLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.last else { return }
         self.location = location
        
         manager.stopUpdatingLocation()
     }
}