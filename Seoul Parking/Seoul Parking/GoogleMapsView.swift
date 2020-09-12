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
        searchHistoryButton.backgroundColor = .white
        searchHistoryButton.tintColor = .black
        searchHistoryButton.clipsToBounds = true
        searchHistoryButton.layer.cornerRadius = 25
        searchHistoryButton.layer.shadowColor = UIColor.black.cgColor
        searchHistoryButton.layer.shadowOffset = .zero
        searchHistoryButton.layer.shadowOpacity = 0.5
        searchHistoryButton.layer.shadowRadius = 5
        searchHistoryButton.layer.masksToBounds = false
        mapView.addSubview(searchHistoryButton)
        searchHistoryButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10).isActive = true
        searchHistoryButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -10).isActive = true
        searchHistoryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        searchHistoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        let settingsButton = UIButton()
        let settingsButtonImage = UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        settingsButtonImage?.withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(settingsButtonImage, for: .normal)
        settingsButton.addTarget(context.coordinator, action: #selector(context.coordinator.settingsButtonPressed(_:)), for: .touchUpInside)
        settingsButton.backgroundColor = .white
        settingsButton.tintColor = .black
        settingsButton.clipsToBounds = true
        settingsButton.layer.cornerRadius = 25
        settingsButton.layer.shadowColor = UIColor.black.cgColor
        settingsButton.layer.shadowOffset = .zero
        settingsButton.layer.shadowOpacity = 0.5
        settingsButton.layer.shadowRadius = 5
        settingsButton.layer.masksToBounds = false

        
        mapView.addSubview(settingsButton)
        settingsButton.topAnchor.constraint(equalTo: searchHistoryButton.bottomAnchor, constant: 10).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -10).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        @objc func settingsButtonPressed(_ sender: UIButton){
            
        }
        
    }
    
}

struct GoogleMapsView_Previews: PreviewProvider {
    
    var parkingSpaces = [ParkingSpace]()
    
    static var previews: some View {
        GoogleMapsView(showSearchHistoryView: .constant(false))
    }
}
