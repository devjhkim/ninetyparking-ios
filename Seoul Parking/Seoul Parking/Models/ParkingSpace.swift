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
    var latitude: Double
    var longitude: Double
}
