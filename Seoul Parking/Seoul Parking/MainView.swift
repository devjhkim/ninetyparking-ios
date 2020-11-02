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
    @EnvironmentObject var notificationCenter: NotificationCenter
    @EnvironmentObject var store: Store
    
    @State var showMenu = false
    @State var auxViewType = AuxViewType()
    @State var showLoginView = false
    @State var showParkingSpaceInfoView = false
    @State var showAvailableTimeView = false
    @State var showPlaceSearchView = false
    @State var showSearchHistoryView = false
    @State var showSettingsView = false
    @State var selectedParkingSpace: ParkingSpace = ParkingSpace()
    @State var navigationBarTitle = APP_TITLE
    
    @State var amount = ""
    @State var oid = ""
    
    var body: some View {
        let drag = DragGesture()
            .onEnded { _ in
                self.showMenu = false
            }
        
        let tap = TapGesture()
            .onEnded { _ in
                self.showMenu = false
                
            }
        
        DispatchQueue.main.async {
            if let payload = self.notificationCenter.payload {
                
                let message = payload.notification.request.content.userInfo
                
                
                if let messageType = message["messageType"] as? String {
                    if messageType == "PAY_REQUEST" {
                        if let amount = message["amount"] as? String, let oid = message["oid"] as? String {
                            self.amount = amount
                            self.oid = oid
                            
                            self.auxViewType.showPaymentMethodSelectionView = true
                        }
                    }
                }
                
                self.notificationCenter.payload = nil
                
            }
        }
        
        
        return ZStack{
            
            
            
            NavigationView {
                
                
                
                GeometryReader(){  reader in
                    
                    
                    ZStack(alignment: .leading) {
                        Group{
                            NavigationLink(destination: AvailableHoursView().environment(\.selectedParkingSpace, self.$selectedParkingSpace), isActive: self.$showAvailableTimeView){
                                EmptyView()
                            }.hidden()
                            
                            NavigationLink(destination: PaymentHistoryView(), isActive: self.$auxViewType.showPaymentHistoryView){
                                EmptyView()
                            }.hidden()
                            
                            NavigationLink(destination: UnpaidPaymentHistoryView(), isActive: self.$auxViewType.showUnpaidPaymentHistoryView){
                                EmptyView()
                            }.hidden()
                            
                            NavigationLink(destination: PaymentMethodSelectionView(amount: self.amount, oid: self.oid), isActive: self.$auxViewType.showPaymentMethodSelectionView){
                                EmptyView()
                            }.hidden()
                            
                            
                            NavigationLink(destination: SearchHistoryView(), isActive: self.$auxViewType.showSearchHistoryView){
                                EmptyView()
                            }.hidden()
                            
                            NavigationLink(destination: SettingsView(auxViewType: self.$auxViewType), isActive: self.$auxViewType.showSettingsView){
                                EmptyView()
                            }.hidden()
                            
                            NavigationLink(destination: AnnouncementsView(), isActive: self.$auxViewType.showAnnouncementsView){
                                EmptyView()
                            }.hidden()
                            
                            NavigationLink(destination: MyInfoView(), isActive: self.$auxViewType.showMyInfoView){
                                EmptyView()
                            }.hidden()
                            
                            
                        }
                        
                        
                        
                        
                        GoogleMapsView(auxViewType: self.$auxViewType)
                            .edgesIgnoringSafeArea(.bottom)
                            .environmentObject(self.lot)
                            .environmentObject(self.centerLocation)
                            .environment(\.showParkingSpaceInfoView, self.$showParkingSpaceInfoView)
                            .environment(\.selectedParkingSpace, self.$selectedParkingSpace)
                        
                        if self.showMenu {
                            
                            MenuView(showMenu: self.$showMenu, auxView: self.$auxViewType, size: CGSize(width: reader.size.width * 0.7, height: reader.size.height))
                                .gesture(tap)
                                .environment(\.showLoginView, self.$showLoginView)
                        }
                        
                        if self.auxViewType.showPasswordCheckAlert {
                            PasswordCheckView(auxViewType: self.$auxViewType)
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
                            .preferredColorScheme(.light)
                            .environmentObject(self.centerLocation)
                            .environmentObject(self.lot)
                    }
                    
                    ZStack{
                        EmptyView()
                    }
                    .alert(isPresented: self.$auxViewType.showWrongPasswordAlert, content: {
                        Alert(title: Text(""), message: Text("잘못된 비밀번호입니다."), dismissButton: .default(Text("확인"), action: {}))
                    })
                    
                    
                    
                }
                .navigationBarTitle(Text(self.centerLocation.place?.name ?? APP_TITLE), displayMode: .inline)
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
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            
            
            
            if self.showParkingSpaceInfoView {
                ParkingSpaceInfoView(auxViewType: self.$auxViewType)
                    .environment(\.showParkingSpaceInfoView, self.$showParkingSpaceInfoView)
                    .environment(\.selectedParkingSpace, self.$selectedParkingSpace)
                    .environment(\.showAvailableTimeView, self.$showAvailableTimeView)
                
            }
            
            if self.auxViewType.showNavigationSelectionView {
                NavigationSelectionView(auxViewType: self.$auxViewType, selectedParkingSpace: self.$selectedParkingSpace)
            }
            
            
        }
        .onAppear(perform: fetchParkingSpaces)
        .onAppear(perform: updateDeviceToken)
        .onAppear(){
            let showAnnouncementsButton = UserDefaults.standard.object(forKey: "showAnnouncementsButton") as? Bool
            
            if showAnnouncementsButton == nil {
                self.auxViewType.showAnnoucementsButton = true
                UserDefaults.standard.setValue(true, forKey: "showAnnouncementsButton")
            }else{
                if let isOn = showAnnouncementsButton {
                    self.auxViewType.showAnnoucementsButton = isOn
                }
            }
            
            let showPaymentHistoryButtons = UserDefaults.standard.object(forKey: "showPaymentHistoryButtons") as? Bool
            
            if showPaymentHistoryButtons == nil {
                self.auxViewType.showPaymentHistoryButtons = true
                UserDefaults.standard.setValue(true, forKey: "showPaymentHistoryButtons")
            }else{
                if let isOn = showPaymentHistoryButtons {
                    self.auxViewType.showPaymentHistoryButtons = isOn
                }
            }
            
            
            
            
            
            
        }
        
        
    }
    
    
    func fetchParkingSpaces() {
        
        guard let url = URL(string: REST_API.SPACE.FETCH) else {
            return
        }
        
        let searchRadius = UserDefaults.standard.object(forKey: "searchRadius") as? Int
        
        if searchRadius == nil {
            self.store.searchRadius = 1
            UserDefaults.standard.setValue(1, forKey: "searchRadius")
        }else{
            if let value = searchRadius {
                self.store.searchRadius = value
            }
        }
        
        let raidus = self.store.searchRadius * 1000
        
        let params = [
            "userUniqueId": "35FC80DC-CB6B-40E0-89A1-7F0DEABDCE7D",
            "latitude" :"37.47846906924382",
            "longitude": "126.95208443935626",
            "address" :  "대한민국 서울특별시 관악구 봉천동 1570-1",
            "radiusArea": raidus.description
            //"latitude" : self.centerLocation.location.latitude,
            //"longitude" : self.centerLocation.location.longitude
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
    
    func updateDeviceToken() {
        guard let url = URL(string: REST_API.USER.UPDATE_DEVICE_TOKEN) else {return}
        
        let params = [
            "userUniqueId": UserInfo.getInstance.uniqueId,
            "iosDeviceToken": UserInfo.getInstance.deviceToken
        ]
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            
            var request = URLRequest(url: url)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonParams
            
            URLSession.shared.dataTask(with: request){(data, response, error) in
                
            }.resume()
        }catch{
            fatalError(error.localizedDescription)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
