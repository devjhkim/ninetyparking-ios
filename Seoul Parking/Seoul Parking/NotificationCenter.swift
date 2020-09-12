//
//  NotificationCenter.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/11.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import Foundation
import SwiftUI

class NotificationCenter: NSObject, ObservableObject {
    @Published var payload : UNNotificationResponse?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationCenter: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        payload = response
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
            
    }
}
