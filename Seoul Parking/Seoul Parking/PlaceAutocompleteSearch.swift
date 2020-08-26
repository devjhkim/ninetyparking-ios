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
    @EnvironmentObject var lot: ParkingLot
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let searchController = GMSAutocompleteViewController()
        searchController.delegate = context.coordinator
        
        return searchController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        
        var controller: PlaceAutocompleteSearch
        
        init(_ controller: PlaceAutocompleteSearch){
            self.controller = controller
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            self.controller.centerLocation.location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            self.controller.presentationMode.wrappedValue.dismiss()
            print(place)
            
            let params = [
                "latitude" : place.coordinate.latitude,
                "longitude" : place.coordinate.longitude
            ]
            
            guard let url = URL(string: REST_API.SPACE.FETCH) else {
                return
            }
            
            do{
                let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
                
                var request = URLRequest(url: url)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = jsonParams
                
                URLSession.shared.dataTask(with: request){(data, response, error) in
                    if data == nil {
                        return
                    }
                    
                    do{
                        if let rawData = data {
                            let parkingSpaces = try JSONDecoder().decode([ParkingSpace].self, from: rawData)
                            
                            DispatchQueue.main.async {
                                self.controller.lot.spaces = parkingSpaces
                            }
                            
                        }
                        
                    }catch{
                        fatalError(error.localizedDescription)
                    }
                }.resume()
                
                
            }catch{
                fatalError(error.localizedDescription)
            }
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            self.controller.presentationMode.wrappedValue.dismiss()
            
        }
        
        
        
        
        
    }
    
}
