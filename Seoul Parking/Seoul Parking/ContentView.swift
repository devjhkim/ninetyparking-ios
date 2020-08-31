//
//  ContentView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/9/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import GoogleMaps

struct AuxLoginViewType {
    var viewType: Category = .none
    var showLoginView: Bool = false
    enum Category: Int {
        case none = 0
        case login = 1
        case loginWithEmail = 2
        case sigup = 3
    }
}

struct ContentView: View {
    
    @EnvironmentObject var centerLocation : CenterLocation
    @EnvironmentObject var lot: ParkingLot
    
    @EnvironmentObject var ld : LogIn
    var profileButton: some View {
        Button(action: {}){
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }

    
    var body: some View {
        ZStack{
            if self.ld.isLoggedIn {
                return AnyView(
                    MainView()
                )
            } else {
                return AnyView(
                    LoginView()
                )
            }

        }
        
    }
    
    
    func fetchParkingSpaces() {
        
        guard let url = URL(string: REST_API.SPACE.FETCH) else {
            return
        }
        
        let params = [
            
            "latitude" : self.centerLocation.location.latitude,
            "longitude" : self.centerLocation.location.longitude
        ]
        
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
                            self.lot.spaces = parkingSpaces
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ShowingLoginViewKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

struct ShowingParkingSpaceInfoViewKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

struct SelectedParkingSpace: EnvironmentKey {
    static let defaultValue: Binding<ParkingSpace>? = nil
}

struct ShowAvailableTimeView: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}


extension EnvironmentValues {
    var showLoginView: Binding<Bool>? {
        get {self[ShowingLoginViewKey.self]}
        set {self[ShowingLoginViewKey.self] = newValue}
    }
    
    var showParkingSpaceInfoView: Binding<Bool>? {
        get{self[ShowingParkingSpaceInfoViewKey.self]}
        set{self[ShowingParkingSpaceInfoViewKey.self] = newValue}
    }
    
    var selectedParkingSpace: Binding<ParkingSpace>? {
        get {self[SelectedParkingSpace.self]}
        set {self[SelectedParkingSpace.self] = newValue}
    }
    
    var showAvailableTimeView: Binding<Bool>? {
        get{self[ShowAvailableTimeView.self]}
        set{self[ShowAvailableTimeView.self] = newValue}
    }
    
    
}

