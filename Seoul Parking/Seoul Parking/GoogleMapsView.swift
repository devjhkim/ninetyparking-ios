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
    
    @Binding var showSearchHistoryView: Bool
    
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
        let searchHistoryButton = UIButton()
        let buttonImage = UIImage(systemName: "list.dash", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        buttonImage?.withRenderingMode(.alwaysTemplate)
        searchHistoryButton.setImage(buttonImage, for: .normal)
        searchHistoryButton.addTarget(context.coordinator, action: #selector(context.coordinator.searchHistoryButtonPressed(_:)), for: .touchUpInside)
        //searchHistoryButton.frame = CGRect(x: 100, y: 60, width: 50, height: 50)
        searchHistoryButton.backgroundColor = .white
        searchHistoryButton.tintColor = .black
        searchHistoryButton.clipsToBounds = true
        searchHistoryButton.layer.cornerRadius = 25
        searchHistoryButton.layer.shadowColor = UIColor.gray.cgColor
        searchHistoryButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchHistoryButton.layer.shadowRadius = 5.0

        
        mapView.addSubview(searchHistoryButton)
        searchHistoryButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 60).isActive = true
        searchHistoryButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -10).isActive = true
        searchHistoryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        searchHistoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchHistoryButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        @objc func searchHistoryButtonPressed(_ sender: UIButton){
            
            self.mapView.showSearchHistoryView = true
        }
        
    }
    
}

struct GoogleMapsView_Previews: PreviewProvider {
    
    var parkingSpaces = [ParkingSpace]()
    
    static var previews: some View {
        GoogleMapsView(showSearchHistoryView: .constant(false))
    }
}
