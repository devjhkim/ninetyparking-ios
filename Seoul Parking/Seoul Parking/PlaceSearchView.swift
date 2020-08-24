//
//  PlaceSearchView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/24/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct PlaceSearchView: View {
    var body: some View {
        PlaceAutocompleteSearch()
    }
}

struct PlaceAutocompleteSearch: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let searchController = GMSAutocompleteViewController()
        let resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = context.coordinator
        
        
        return searchController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, GMSAutocompleteResultsViewControllerDelegate {
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
            print(place)
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
            
        }
        
        
    }
    
}


struct SearchBar: UIViewRepresentable {
    
    typealias UIViewType = UISearchBar
    
    func makeUIView(context: Context) -> UISearchBar {
        
        let resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = context.coordinator
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.showsCancelButton = true
        //searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController.searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    
    class Coordinator: NSObject, GMSAutocompleteResultsViewControllerDelegate {
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
             print("Place name: \(place.name)")
               print("Place address: \(place.formattedAddress)")
               print("Place attributions: \(place.attributions)")
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
            
        }
        
        
    }
}

struct PlaceSearchController: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        
        let resultsViewController = GMSAutocompleteResultsViewController()
        
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.sizeToFit()
        
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        
        
        return autocompleteController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        
        var viewController: PlaceSearchController
        
        init(_ controller: PlaceSearchController){
            self.viewController = controller
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            
        }
        
  
        
    }
    
}

struct PlaceSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSearchView()
    }
}

class AutocompleteSearchController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
