//
//  GoogleMapsView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/9/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import GoogleMaps


struct GoogleMapsView: UIViewRepresentable {
    private let zoom: Float = 15.0
    
    @Binding var location: CLLocation
    @EnvironmentObject var lot: ParkingLot
    
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition.camera(withLatitude: self.location.latitude, longitude: self.location.longitude, zoom: 15.0)
        
        mapView.animate(to: camera)
        mapView.clear()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.location.latitude, longitude: self.location.longitude)
        marker.map = mapView
        
        lot.spaces.forEach { space in
            let latitude = space.latitude
            let longitude = space.longitude
            
            let pin = GMSMarker()
            pin.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            pin.icon = GMSMarker.markerImage(with: .blue)
            pin.map = mapView
        }
        
    }
    
    func addParkingSpaces() {
        
    }
    
    
}

struct GoogleMapsView_Previews: PreviewProvider {
    
    var parkingSpaces = [ParkingSpace]()
    
    static var previews: some View {
        GoogleMapsView(location: .constant(CLLocation()) )
    }
}
