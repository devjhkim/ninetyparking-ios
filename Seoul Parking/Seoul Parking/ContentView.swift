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
    @State var showParkingSpaceInfoView = false
    @State var showAvailableTimeView = false
    @State var selectedParkingSpace: ParkingSpace = ParkingSpace()
    
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
            .onEnded { _ in
                self.showMenu = false
        }
        
        let tap = TapGesture()
            .onEnded { _ in
                self.showMenu = false
                
        }
        
        
        return ZStack{
            
            
            
            NavigationView {
                
                
                
                GeometryReader(){  reader in
                    
                    ZStack(alignment: .leading) {
                        
                        NavigationLink(destination: AvailableHoursView().environment(\.selectedParkingSpace, self.$selectedParkingSpace), isActive: self.$showAvailableTimeView){
                            EmptyView()
                        }.hidden()
                        
                        GoogleMapsView(location: .constant(self.locationManager.location ?? CLLocation()))
                            .edgesIgnoringSafeArea(.bottom)
                            .environmentObject(self.lot)
                            .environment(\.showParkingSpaceInfoView, self.$showParkingSpaceInfoView)
                            .environment(\.selectedParkingSpace, self.$selectedParkingSpace)
                        
                        
                        if self.showMenu {
                            
                            MenuView(showMenu: self.$showMenu, auxLoginView: self.$auxLoginViewType, width: reader.size.width * 0.7, size: CGSize(width: reader.size.width * 0.7, height: reader.size.height))
                                .gesture(tap)
                        }
                        
                        
                        
                    }
                    .gesture(drag)
                    .sheet(isPresented:self.$auxLoginViewType.showLoginView){
                        LoginView()
                            .environment(\.showLoginView, self.$auxLoginViewType.showLoginView)
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
                    }
                )
                    .background(NavigationConfigurator {nc in
                        nc.navigationBar.barTintColor = .white
                        nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
                    })
                    .onAppear(perform: loadData)
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

