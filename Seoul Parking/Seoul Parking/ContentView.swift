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
    @State var rect: CGRect = CGRect()
    
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
        
        GeometryReader(){  reader in
            
            HStack {
                MenuView()
                    .offset(x: 0, y: 0)
                    .frame(width: reader.size.width, height: reader.size.height)
                    .background(Color.red)
                
                NavigationView{
                    GoogleMapsView(location: .constant(self.locationManager.location!))
                    
                        

                    .edgesIgnoringSafeArea(.bottom)

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
                .offset(x: reader.size.width, y: 0)
                .frame(width: reader.size.width, height: reader.size.height)
                .background(Color.yellow)
            }
            .offset(x:-reader.size.width, y: 0)
            .frame(width: reader.size.width * 2, height: reader.size.height)
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    func makeView(_ geometry: GeometryProxy) -> some View {
        
        print(rect.size.width, rect.size.height)
        

        
        var stack: some View {
            Text("fff")
        }
            
        
        return stack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
