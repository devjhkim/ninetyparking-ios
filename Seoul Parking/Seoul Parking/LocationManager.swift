//
//  LocationManager.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/10/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    let objectWillChange = PassthroughSubject<Void, Never>()

    @Published var status: CLAuthorizationStatus? {
      willSet { objectWillChange.send() }
    }

    @Published var location: CLLocation? {
      willSet { objectWillChange.send() }
    }
    
    @Published var placemark: CLPlacemark? {
      willSet { objectWillChange.send() }
    }


    override init() {
      super.init()

      self.locationManager.delegate = self
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
      self.locationManager.requestWhenInUseAuthorization()
      self.locationManager.startUpdatingLocation()
    }

    private func geocode() {
      guard let location = self.location else { return }
      geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
        if error == nil {
          self.placemark = places?[0]
        } else {
          self.placemark = nil
        }
      })

    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        self.status = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
        manager.stopUpdatingLocation()
    }
}

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}

