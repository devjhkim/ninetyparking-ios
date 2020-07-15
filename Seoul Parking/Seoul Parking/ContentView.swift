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
    
    
    @EnvironmentObject var lot: ParkingLot
    
    
    @State private var showMenu = false
    
    
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
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
        }
        
        let tap = TapGesture()
            .onEnded{ _ in
                withAnimation {
                    self.showMenu = false
                }
                
        }
        
        
        return NavigationView {
            GeometryReader(){  reader in
                
                ZStack(alignment: .leading) {
                    
                    
                    GoogleMapsView(location: .constant(self.locationManager.location ?? CLLocation()))
                        .edgesIgnoringSafeArea(.bottom)
                        .environmentObject(self.lot)
                        
                        
                    if self.showMenu {
                        HStack{
                            MenuView()
                            
                            .frame(width: reader.size.width / 2, alignment: .leading)
                            
                            .transition(.move(edge: .leading))
                            
                            Spacer()
                            Spacer()

                        }
                        .frame(width: reader.size.width)
                        
                    .gesture(tap)
                    }
                    
                }
                .gesture(drag)
                
            }
            .navigationBarTitle("서울 주차장", displayMode: .inline)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
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
            .onAppear(perform: loadData)
        }
        
        
        
        
        
        
        
        
    }
    
    func loadData() {
        
        guard let url = URL(string: REST_API.SPACE.FETCH) else {
            return
        }
        let request = URLRequest(url: url)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
