//
//  Constants.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/9/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

public let GOOGLE_MAPS_API_KEY = "AIzaSyBs3cfv9i6RszPn5N2Cjg3tPAEW_s5e_rQ"
public let GOOGLE_PLACES_API_KEY = "AIzaSyDFTi7tbp7f_hKLx5piWY3ybYNaIJoQo2I"
public let KAKAO_API_KEY = "e0da816370091f321c148544edf371c2"
public let SERVER_IP = "10.8.7.160"
public let SERVER_PORT = "49090"
public let APP_TITLE = "나인티 파킹"
   
struct APP_SERVER {
    
    public static let HOST = "http://" + SERVER_IP + ":" + SERVER_PORT
}

struct REST_API {
    struct SPACE {
        public static let FETCH = APP_SERVER.HOST + "/api/space/fetch"
    }
    
    struct USER {
        public static let LOG_IN = APP_SERVER.HOST + "/api/user/login"
        public static let SIGN_UP = APP_SERVER.HOST + "/api/user/signup"
    }
    
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
