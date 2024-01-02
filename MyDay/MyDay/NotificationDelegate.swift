//
//  NotificationDelegate.swift
//  MyDay
//
//  Created by Stefanie on 31.12.23.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Received notification interaction.")
        
        switch response.actionIdentifier {
        case "acceptAction":
            print("acceptAction")
        case "declineAction":
            print("declineAction")
        default:
            break
        }

        completionHandler()
    }
     
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }
    
}
