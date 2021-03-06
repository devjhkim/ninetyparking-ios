//
//  ContentView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/9/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import GoogleMaps

struct AuxViewType {
    
    var showLoginView: Bool = false
    var showPaymentHistoryView: Bool = false
    var showUnpaidPaymentHistoryView: Bool = false
    var showSearchHistoryView: Bool = false
    var showSettingsView: Bool = false
    var showPasswordCheckAlert: Bool = false
    var showWrongPasswordAlert: Bool = false
    var showPaymentMethodSelectionView: Bool = false
    var showAnnouncementsView: Bool = false
    var showMyInfoView: Bool = false
    var showAnnoucementsButton: Bool = true
    var showPaymentHistoryButtons: Bool = true
    var showNavigationSelectionView: Bool = false
    
}

struct ContentView: View {
    
    @EnvironmentObject var centerLocation : CenterLocation
    @EnvironmentObject var lot: ParkingLot
    @EnvironmentObject var ld : LogIn
    @EnvironmentObject var notificationCenter: NotificationCenter
    @EnvironmentObject var store: Store
    
    init() {

        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = false

        
    }
    
    var body: some View {
        if self.ld.isLoggedIn {
            return AnyView(
                MainView()
                    .preferredColorScheme(.light)
                    .onAppear(perform: {
                        
                        if let loggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool {
                            self.ld.isLoggedIn = loggedIn
                            
                            getUserInfo()
                            
                            self.store.user.name = UserInfo.getInstance.name
                            self.store.user.email = UserInfo.getInstance.email
                            self.store.user.plateNumbers = UserInfo.getInstance.plateNumbers
                            self.store.user.userUniqueId = UserInfo.getInstance.uniqueId
                        }
                        
                        
                    })
            )
            
        } else {
            return AnyView(
                LoginView()
                    .preferredColorScheme(.light)
                    .onAppear(perform: {
                        if let loggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool {
                            self.ld.isLoggedIn = loggedIn
                        }

                    })
            )
            
            
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

