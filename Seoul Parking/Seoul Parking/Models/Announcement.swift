//
//  Announcement.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/27.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Foundation

struct Announcement: Hashable, Codable {
    var date: String
    var title: String
    var announcement: String
}
