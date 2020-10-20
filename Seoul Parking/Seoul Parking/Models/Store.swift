//
//  Store.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/16.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Foundation
import SwiftUI

final class Store: ObservableObject {
    @Published var user = User()
}

struct User: Hashable, Codable {
    var userUniqueId : String = ""
    var name: String = ""
    var email: String = ""
    var plateNumbers: [String] = [String]()
    var password: String = ""
}
