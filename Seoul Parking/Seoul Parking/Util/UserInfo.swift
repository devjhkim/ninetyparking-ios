//
//  UserInfo.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/28/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Foundation


class UserInfo {
    static let getInstance = UserInfo()
    
    private var _name: String = ""
    private var _uniqueId: String = ""
    private var _email: String = ""
    private var _plateNumbers = [String]()
    private var _isLoggedIn: Bool = false
    private var _deviceToken: String = ""

    var name: String {
        get { return _name }
        set(n) {_name = n}
    }


    var uniqueId: String {
        get { return _uniqueId}
        set(u) {_uniqueId = u}
    }
    
    var isLoggedIn : Bool {
        get { return _isLoggedIn }
        set(i) {_isLoggedIn = i}
    }
    
    var deviceToken : String {
        get { return _deviceToken }
        set(t) {_deviceToken = t}
    }
    
    var email: String {
        get { return _email }
        set(e) { _email = e}
    }
    
    var plateNumbers: [String] {
        get {return _plateNumbers}
        set(p) {_plateNumbers = p}
    }
}

func handleLogInResult(_ data: LoginData){
    UserDefaults.standard.set(true, forKey: "isLoggedIn")
    UserDefaults.standard.set(data.name, forKey: "userName")
    UserDefaults.standard.set(data.userUniqueId, forKey: "userUniqueId")
    UserDefaults.standard.set(data.email, forKey: "email")
    UserDefaults.standard.set(data.plateNumbers, forKey: "plateNumbers")
    
    UserInfo.getInstance.name = data.name
    UserInfo.getInstance.uniqueId = data.userUniqueId
    UserInfo.getInstance.isLoggedIn = true
    UserInfo.getInstance.email = data.email
    UserInfo.getInstance.plateNumbers = data.plateNumbers
}

func handleLogout(){
    UserDefaults.standard.set(false, forKey: "isLoggedIn")
    UserDefaults.standard.removeObject(forKey: "userName")
    UserDefaults.standard.removeObject(forKey: "userUniqueId")
    UserDefaults.standard.removeObject(forKey: "email")
    UserDefaults.standard.removeObject(forKey: "plateNumbers")
    UserInfo.getInstance.name = ""
    UserInfo.getInstance.uniqueId = ""
    UserInfo.getInstance.isLoggedIn = false
    UserInfo.getInstance.email = ""
    UserInfo.getInstance.plateNumbers = [""]
}

func getUserInfo() {
    if let name = UserDefaults.standard.value(forKey: "userName") as? String {
        UserInfo.getInstance.name = name
    }
    
    if let uniqueId = UserDefaults.standard.value(forKey: "userUniqueId") as? String {
        UserInfo.getInstance.uniqueId = uniqueId
    }
    
    if let email = UserDefaults.standard.value(forKey: "email") as? String {
        UserInfo.getInstance.email = email
    }
    
    if let plateNumbers = UserDefaults.standard.value(forKey: "plateNumbers") as? [String] {
        UserInfo.getInstance.plateNumbers = plateNumbers
    }
    
}
