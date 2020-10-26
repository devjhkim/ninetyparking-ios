//
//  SearchHistory.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/22.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Combine

struct SearchHistory: Hashable, Codable {
    var historyUniqueId: String
    var address: String
    var longitude: Double
    var latitude: Double
}
