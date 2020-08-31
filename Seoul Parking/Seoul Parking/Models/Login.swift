//
//  Login.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/22/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Foundation


class LogIn: ObservableObject {
    @Published var isLoggedIn = UserInfo.getInstance.isLoggedIn
}

struct LoginData: Hashable, Codable {
    var userUniqueId: String
    var statusCode: String
    var name: String
}

struct LoginResult {
    var showAlert: Bool = false
    var statusCode: String = ""
    var kakaoId  = ""
    var facebookId = ""
    var naverId = ""
    
}
