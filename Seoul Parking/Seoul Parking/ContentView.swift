//
//  ContentView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/9/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import GoogleMaps


struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    
    
    var profileButton: some View {
        Button(action: {}){
            Image(systemName: "person.crop.circle")
            .imageScale(.large)
            .accessibility(label: Text("User Profile"))
            .padding()
        }
    }
    
    var currLng : String { return("\(locationManager.location?.longitude ?? 0)")}
    var currLat: String { return("\(locationManager.location?.latitude ?? 0)")}
    var body: some View {
        NavigationView{
            VStack{
                GoogleMapsView(location: .constant(locationManager.location!))
                
                    .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
                
            }
        .navigationBarTitle(Text("서울 주차장"))
            .navigationBarItems(leading:
                HStack {
                    Button("Menu") {
                        print("Hours tapped!")
                    }
                }, trailing:
                HStack {
                    Button("Favorites") {
                        print("Favorites tapped!")
                    }

                    Button("Specials") {
                        print("Specials tapped!")
                    }
                }
            )
                
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
