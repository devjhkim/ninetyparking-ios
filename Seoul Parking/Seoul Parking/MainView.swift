//
//  MainView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/31/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var centerLocation : CenterLocation
    @EnvironmentObject var lot: ParkingLot
    @State var showMenu = false
    @State var auxLoginViewType: AuxLoginViewType = AuxLoginViewType()
    @State var showLoginView = false
    @State var showParkingSpaceInfoView = false
    @State var showAvailableTimeView = false
    @State var showPlaceSearchView = false
    @State var selectedParkingSpace: ParkingSpace = ParkingSpace()
    
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
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .preferredColorScheme(.dark)
            
            
            
            if self.showParkingSpaceInfoView {
                ParkingSpaceInfoView()
                    .environment(\.showParkingSpaceInfoView, self.$showParkingSpaceInfoView)
                    .environment(\.selectedParkingSpace, self.$selectedParkingSpace)
                    .environment(\.showAvailableTimeView, self.$showAvailableTimeView)
                
            }
            
            
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
