//
//  Constants.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/9/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

public let GOOGLE_MAPS_API_KEY = "AIzaSyBlalpyrjUftPgmWiQhWeEIxlbvv2JxqDg"

struct APP_SERVER {
    public static let HOST = "http://10.3.7.224:49090"
}

struct REST_API {
    struct SPACE {
        public static let FETCH = APP_SERVER.HOST + "/api/space/fetch"
    }
}


