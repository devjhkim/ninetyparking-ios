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
    private var _isLoggedIn: Bool = false

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
}

func handleLogInResult(_ data: LoginData){
    UserDefaults.standard.set(true, forKey: "isLoggedIn")
    UserDefaults.standard.set(data.name, forKey: "userName")
    UserDefaults.standard.set(data.userUniqueId, forKey: "userUniqueId")
    
    UserInfo.getInstance.name = data.name
    UserInfo.getInstance.uniqueId = data.userUniqueId
    UserInfo.getInstance.isLoggedIn = true
}
