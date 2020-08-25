//
//  PlaceAutocompleteSearch.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/25/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//


import SwiftUI
import GooglePlaces


struct PlaceAutocompleteSearch: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var centerLocation: CenterLocation
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let searchController = GMSAutocompleteViewController()
        searchController.delegate = context.coordinator
        let resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = context.coordinator
        
        
        return searchController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, GMSAutocompleteResultsViewControllerDelegate, GMSAutocompleteViewControllerDelegate {
        
        var controller: PlaceAutocompleteSearch
        
        init(_ controller: PlaceAutocompleteSearch){
            self.controller = controller
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            self.controller.centerLocation.location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            self.controller.presentationMode.wrappedValue.dismiss()
            print(place)
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            self.controller.presentationMode.wrappedValue.dismiss()
            
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
            print(place)
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
            
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
            print(prediction)
            
            return true
        }
        
        
        
        
    }
    
}
