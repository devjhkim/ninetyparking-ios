//
//  Extension.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/18/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Foundation

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
