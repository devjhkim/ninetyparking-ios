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
    @State var showMenu = false
    @State var auxLoginViewType: AuxLoginViewType = AuxLoginViewType()
    @State var showLoginView = false
    @State var showParkingSpaceInfoView = false
    @State var showAvailableTimeView = false
    @State var showPlaceSearchView = false
    @State var selectedParkingSpace: ParkingSpace = ParkingSpace()
    
    var profileButton: some View {
        Button(action: {}){
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }

    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded { _ in
                self.showMenu = false
        }
        
        let tap = TapGesture()
            .onEnded { _ in
                self.showMenu = false
                
        }
        
        if UserInfo.getInstance.isLoggedIn {
            
        }
        
        return ZStack{
            
            
            
            NavigationView {
                
                
                
                GeometryReader(){  reader in
                    
                    ZStack(alignment: .leading) {
                        
                        NavigationLink(destination: AvailableHoursView().environment(\.selectedParkingSpace, self.$selectedParkingSpace), isActive: self.$showAvailableTimeView){
                            EmptyView()
                        }.hidden()
                        
                        
                                        
                        GoogleMapsView()
                            .edgesIgnoringSafeArea(.bottom)
                            .environmentObject(self.lot)
                            .environmentObject(self.centerLocation)
                            .environment(\.showParkingSpaceInfoView, self.$showParkingSpaceInfoView)
                            .environment(\.selectedParkingSpace, self.$selectedParkingSpace)
                        
                        
                        if self.showMenu {
                            
                            MenuView(showMenu: self.$showMenu, auxLoginView: self.$auxLoginViewType, size: CGSize(width: reader.size.width * 0.7, height: reader.size.height))
                                .gesture(tap)
                                .environment(\.showLoginView, self.$showLoginView)
                        }
                        
                        
                       
                        
                        
                    }
                    .gesture(drag)
                    .sheet(isPresented:self.$showLoginView){
                        LoginView()
                            .environment(\.showLoginView, self.$showLoginView)
                    }
                    
                    ZStack{
                        EmptyView()
                    }
                    .sheet(isPresented: self.$showPlaceSearchView){
                        PlaceAutocompleteSearch()
                            .environmentObject(self.centerLocation)
                            .environmentObject(self.lot)
                    }
                    
                }
                .navigationBarTitle(Text(APP_TITLE), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }){
                        Image(systemName: "line.horizontal.3")
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .imageScale(.large)
                            .padding()
                    },
                                    
                    trailing: Button(action: {self.showPlaceSearchView = true}){
                        Image(systemName: "magnifyingglass")
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .imageScale(.large)
                            .padding()
                                        
                    }
                )
                .background(NavigationConfigurator {nc in
                    nc.navigationBar.barTintColor = .white
                    nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
                })
                .onAppear(perform: fetchParkingSpaces)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .preferredColorScheme(.dark)
            .onAppear(perform: {
                if let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool {
                    if isLoggedIn {
                        UserInfo.getInstance.isLoggedIn = true
                        if let name = UserDefaults.standard.value(forKey: "userName") as? String, let userUniqueId = UserDefaults.standard.value(forKey: "userUniqueId") as? String {
                            UserInfo.getInstance.name = name
                            UserInfo.getInstance.uniqueId = userUniqueId
                        }
                    }
                }
            })
            
            
            if self.showParkingSpaceInfoView {
                ParkingSpaceInfoView()
                    .environment(\.showParkingSpaceInfoView, self.$showParkingSpaceInfoView)
                    .environment(\.selectedParkingSpace, self.$selectedParkingSpace)
                    .environment(\.showAvailableTimeView, self.$showAvailableTimeView)
                
            }
            
            LoginView()
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

