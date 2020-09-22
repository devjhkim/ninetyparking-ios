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
    var spaceUniqueId: String = ""
    var spaceName: String = ""
    var address: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var chargePerTenMinute: String = ""
    var availableTime: [[Int]] = [[0,0]]
    var availability: String = ""
    var statusCode: String = ""
    var currentTime: String = ""
    var distance: Double = 0
}
