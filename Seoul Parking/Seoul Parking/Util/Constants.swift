//
//  Constants.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/9/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

public let KG_INICIS_MID = "INIpayTest"
public let GOOGLE_MAPS_API_KEY = "AIzaSyBs3cfv9i6RszPn5N2Cjg3tPAEW_s5e_rQ"
public let GOOGLE_PLACES_API_KEY = "AIzaSyDFTi7tbp7f_hKLx5piWY3ybYNaIJoQo2I"
public let KAKAO_API_KEY = "e0da816370091f321c148544edf371c2"
public let TMAP_API_KEY = "l7xxd0cafeae85ca47de983bd3a96e17d3e9" // "l7xx40ffcbbeca0d4d46915537979af41f51"

public let SERVER_PORT = "49090"

//public let SERVER_IP = "10.8.1.180" + ":" + SERVER_PORT
public let SERVER_IP = "ninetysystem.cafe24.com"

public let APP_TITLE = "나인티 파킹"


//Commit Test to master

struct APP_SERVER {
    
    public static let HOST = "https://" + SERVER_IP
}

struct REST_API {
    struct SPACE {
        public static let FETCH = APP_SERVER.HOST + "/api/space/fetch"
        public static let SEARCH_HISTORY = APP_SERVER.HOST + "/api/space/search/history"
        public static let DELETE_HISTORY = APP_SERVER.HOST + "/api/space/delete/history"
        public static let FETCH_ANNOUNCEMENTS = APP_SERVER.HOST + "/api/space/announcements"
    }
    
    struct USER {
        public static let LOG_IN = APP_SERVER.HOST + "/api/user/login"
        public static let SIGN_UP = APP_SERVER.HOST + "/api/user/signup"
        public static let UPDATE_DEVICE_TOKEN = APP_SERVER.HOST + "/api/user/update/deviceToken"
        public static let CHECK_PASSWORD = APP_SERVER.HOST + "/api/user/check/password"
        
        struct UPDATE {
            public static let DEVICE_TOKEN = APP_SERVER.HOST + "/api/user/update/deviceToken"
            public static let EMAIL = APP_SERVER.HOST + "/api/user/update/email"
            public static let NAME = APP_SERVER.HOST + "/api/user/update/name"
            public static let PLATE_NUMBERS = APP_SERVER.HOST + "/api/user/update/plateNumbers"
            public static let PASSWORD = APP_SERVER.HOST + "/api/user/update/password"
        }
    }
    
    struct MENU {
        public static let PAYMENT_HISTORY = APP_SERVER.HOST + "/api/menu/paymentHistory"
    }
    
    
    public static let PAY_NEXT_URL = APP_SERVER.HOST + "/api/pay/next"
    public static let PAY_VBANK_URL = APP_SERVER.HOST + "/api/pay/vbank"
    
    struct PAY {
        public static let REQUEST = "https://mobile.inicis.com/smart/payment/"
    }
    

}

struct PASSWORD_LENGTH {
    public static let MIN = 4
    public static let MAX = 8
}

struct NAME_LENGTH {
    public static let MIN = 2
}

public let MAX_PLATE_NUMBERS = 3

func requestLogIn(params: [String: String?], finished: @escaping ((_ data: LoginData) -> Void)){
    do{
        let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
        if let url = URL(string: REST_API.USER.LOG_IN) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonParams
            
            URLSession(configuration: .default).dataTask(with: request){ (data, response, error) in
                if data == nil {
                    return
                }
                
                do{
                    if let rawData = data {
                        let login = try JSONDecoder().decode(LoginData.self, from: rawData)
                        
                        
                        
                        DispatchQueue.main.async {

                            finished(login)
                            
                        }

                   }

               }catch{
                   fatalError(error.localizedDescription)
               }
            }.resume()
        }
        
    }catch{
        
    }
}
