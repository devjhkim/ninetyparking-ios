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
    @ObservedObject var locationManager = LocationManager()
    @EnvironmentObject var lot: ParkingLot
    @State var showMenu = false
    @State var auxLoginViewType: AuxLoginViewType = AuxLoginViewType()
    @State var showLoginView = false
    
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
        
//        let drag = DragGesture()
//            .onEnded {
//                if $0.translation.width < -100 {
//                    withAnimation {
//                        self.showMenu = false
//                    }
//                }
//        }
//
//        let tap = TapGesture()
//            .onEnded{ _ in
//                withAnimation {
//                    self.showMenu = false
//                }
//
//
//
//        }
        
        
        NavigationView {
            GeometryReader(){  reader in
                
                ZStack(alignment: .leading) {
                    
                    
                    GoogleMapsView(location: .constant(self.locationManager.location ?? CLLocation()))
                        .edgesIgnoringSafeArea(.bottom)
                        .environmentObject(self.lot)
                        
                        
                    if self.showMenu {
                        HStack{
                            MenuView(showMenu: self.$showMenu, auxLoginView: self.$auxLoginViewType)
                            
                            .frame(width: reader.size.width / 2, alignment: .leading)
                            
                            .transition(.move(edge: .leading))
                            
                            Spacer()
                            Spacer()

                        }
                        .frame(width: reader.size.width)
                        
                        //.gesture(tap)
                    }
                    
                }
                //.gesture(drag)
                .sheet(isPresented:self.$auxLoginViewType.showLoginView){
                    LoginView()
                }
                
            }
            .navigationBarTitle("서울 주차장", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }){
                    Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                }
                
//                NavigationLink(destination: EmailLoginView(), isActive: self.$showLoginView){
//                    Button(action: {
//                        self.showLoginView = !self.showLoginView
//                    }){
//                        Image(systemName: "line.horizontal.3")
//                            .imageScale(.large)
//                    }
//                }
                

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
