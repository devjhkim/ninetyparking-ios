//
//  Payment.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/22.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Combine
import SwiftUI

struct Payment: Hashable, Codable {
    var paymentUniqueId: String = ""
    var date: String = ""
    var address: String = ""
    var isPaid: Bool = false
    var amount: String = ""
}

