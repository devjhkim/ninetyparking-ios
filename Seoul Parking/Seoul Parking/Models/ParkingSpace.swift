//
//  ParkingSpace.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/14/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Combine
import SwiftUI

final class ParkingLot: ObservableObject{
    @Published var spaces = [ParkingSpace]()
}

struct ParkingSpace: Hashable, Codable {
    var spaceId: String
    var address: String
    var latitude: Double
    var longitude: Double
    var info: String
    var availableTime: [[Int]]
    var availability: String
    var statusCode: String
    var currentTime: String
    var distance: Double
    
    init() {
        spaceId = ""
        address = ""
         latitude = 0
         longitude = 0
         info = ""
        availableTime = [[0,0]]
         availability = ""
         statusCode = ""
         currentTime = ""
        distance = 0
    }
}
