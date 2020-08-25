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
    
    
    @EnvironmentObject var lot: ParkingLot
    @EnvironmentObject var centerLocation: CenterLocation
    @Environment(\.showParkingSpaceInfoView) var showParkingSpaceInfoView
    @Environment(\.selectedParkingSpace) var selectedParkingSpace
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition.camera(withLatitude: self.centerLocation.location.latitude, longitude: self.centerLocation.location.longitude, zoom: 15.0)
        
        mapView.animate(to: camera)
        mapView.clear()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.centerLocation.location.latitude, longitude: self.centerLocation.location.longitude)
        marker.map = mapView
        
        lot.spaces.forEach { space in
            let latitude = space.latitude
            let longitude = space.longitude
            
            let pin = GMSMarker()
            pin.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            pin.icon = GMSMarker.markerImage(with: .blue)
            pin.userData = space
            pin.map = mapView
        }
        
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var mapView : GoogleMapsView
        
        init(_ mapView: GoogleMapsView) {
            self.mapView = mapView
            
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
         
            if let spaceData = marker.userData as? ParkingSpace {
                
                
                self.mapView.selectedParkingSpace?.wrappedValue = spaceData
                
                self.mapView.showParkingSpaceInfoView?.wrappedValue = true
                
                
            }
            
            return true
        }
        
    }
    
}

struct GoogleMapsView_Previews: PreviewProvider {
    
    var parkingSpaces = [ParkingSpace]()
    
    static var previews: some View {
        GoogleMapsView()
    }
}
