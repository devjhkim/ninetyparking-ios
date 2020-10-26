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
    
    
    @Binding var auxViewType: AuxViewType
    private let zoom: Float = 15.0
    
    @State var currParkingLot: ParkingLot = ParkingLot()
    @EnvironmentObject var lot: ParkingLot
    @EnvironmentObject var centerLocation: CenterLocation
    @Environment(\.showParkingSpaceInfoView) var showParkingSpaceInfoView
    @Environment(\.selectedParkingSpace) var selectedParkingSpace
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        DispatchQueue.main.async {
            self.currParkingLot = self.lot
        }
        
        
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
        let settingsButtonImage = UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
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
        
        
        let showAllButton = UIButton()
        showAllButton.setTitle("전체", for: .normal)
        showAllButton.setTitleColor(.black, for: .normal)
        showAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        showAllButton.addTarget(context.coordinator, action: #selector(context.coordinator.showAllParkingLots(_:)), for: .touchUpInside)
        showAllButton.backgroundColor = .white
        showAllButton.clipsToBounds = true
        showAllButton.layer.cornerRadius = 25
        showAllButton.layer.shadowColor = UIColor.black.cgColor
        showAllButton.layer.shadowOffset = .zero
        showAllButton.layer.shadowOpacity = 0.5
        showAllButton.layer.shadowRadius = 5
        showAllButton.layer.masksToBounds = false
        mapView.addSubview(showAllButton)
        showAllButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50).isActive = true
        showAllButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 80).isActive = true
        showAllButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showAllButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let showAvailableButton = UIButton()
        showAvailableButton.setTitle("주차가능", for: .normal)
        showAvailableButton.setTitleColor(.black, for: .normal)
        showAvailableButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        showAvailableButton.addTarget(context.coordinator, action: #selector(context.coordinator.showAvailableParkingLots(_:)), for: .touchUpInside)
        showAvailableButton.backgroundColor = .white
        showAvailableButton.clipsToBounds = true
        showAvailableButton.layer.cornerRadius = 25
        showAvailableButton.layer.shadowColor = UIColor.black.cgColor
        showAvailableButton.layer.shadowOffset = .zero
        showAvailableButton.layer.shadowOpacity = 0.5
        showAvailableButton.layer.shadowRadius = 5
        showAvailableButton.layer.masksToBounds = false
        mapView.addSubview(showAvailableButton)
        showAvailableButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50).isActive = true
        showAvailableButton.leftAnchor.constraint(equalTo: showAllButton.rightAnchor, constant: 20).isActive = true
        showAvailableButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showAvailableButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showAvailableButton.translatesAutoresizingMaskIntoConstraints = false
        
        let showUnavailableButton = UIButton()
        showUnavailableButton.setTitle("주차불가", for: .normal)
        showUnavailableButton.setTitleColor(.black, for: .normal)
        showUnavailableButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        showUnavailableButton.addTarget(context.coordinator, action: #selector(context.coordinator.showUnavailableParkingLots(_:)), for: .touchUpInside)
        showUnavailableButton.backgroundColor = .white
        showUnavailableButton.clipsToBounds = true
        showUnavailableButton.layer.cornerRadius = 25
        showUnavailableButton.layer.shadowColor = UIColor.black.cgColor
        showUnavailableButton.layer.shadowOffset = .zero
        showUnavailableButton.layer.shadowOpacity = 0.5
        showUnavailableButton.layer.shadowRadius = 5
        showUnavailableButton.layer.masksToBounds = false
        mapView.addSubview(showUnavailableButton)
        showUnavailableButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50).isActive = true
        showUnavailableButton.leftAnchor.constraint(equalTo: showAvailableButton.rightAnchor, constant: 20).isActive = true
        showUnavailableButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showUnavailableButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showUnavailableButton.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition.camera(withLatitude: self.centerLocation.location.latitude, longitude: self.centerLocation.location.longitude, zoom: 15.0)
        
        mapView.animate(to: camera)
        mapView.clear()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.centerLocation.location.latitude, longitude: self.centerLocation.location.longitude)
        marker.map = mapView
        
        currParkingLot.spaces.forEach { space in
            let latitude = space.latitude
            let longitude = space.longitude
            
            let pin = GMSMarker()
            pin.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            if space.availability == "1"{
                pin.icon = GMSMarker.markerImage(with: .blue)
            }else{
                pin.icon = GMSMarker.markerImage(with: .lightGray)
            }
            
            
            pin.userData = space
            pin.title = space.spaceName
            pin.snippet = "10분당 " + space.chargePerTenMinute + "원"
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
            
            return false
        }
        
        @objc func searchHistoryButtonPressed(_ sender: UIButton){
            
            self.mapView.auxViewType.showSearchHistoryView = true
        }
        
        @objc func settingsButtonPressed(_ sender: UIButton){
            self.mapView.auxViewType.showPasswordCheckAlert = true
            
            
        }
        
        @objc func showAllParkingLots(_ sender: UIButton){
            self.mapView.currParkingLot = self.mapView.lot
        }
        
        @objc func showAvailableParkingLots(_ sender: UIButton){
            let availableParkingLots = ParkingLot()
            self.mapView.lot.spaces.forEach{ space in
                if space.availability == "1"{
                    availableParkingLots.spaces.append(space)
                }
            }
            
            self.mapView.currParkingLot = availableParkingLots
        }
        
        @objc func showUnavailableParkingLots(_ sender: UIButton){
            let availableParkingLots = ParkingLot()
            self.mapView.lot.spaces.forEach{ space in
                if space.availability == "0"{
                    availableParkingLots.spaces.append(space)
                }
            }
            
            self.mapView.currParkingLot = availableParkingLots
        }
        
        
    }
    
}

class MapIconView: UIView {
    var address = ""
    var price = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
