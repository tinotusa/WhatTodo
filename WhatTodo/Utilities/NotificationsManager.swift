//
//  NotificationsManager.swift
//  NotificationsManager
//
//  Created by Tino on 17/9/21.
//

import Foundation
import UserNotifications

struct NotificationsManager {
    static let userNotifications = UNUserNotificationCenter.current()
    
    static func requestUserNotificationAuthorization() {
        userNotifications.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { success, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // do stuff
            print("requested")
        }
    }
     
    static func addNotification(for todo: Todo) {
         if !todo.hasReminder {
             return
         }
         // notification's content
         let content = UNMutableNotificationContent()
         content.title = todo.wrappedTitle
         content.body = todo.wrappedDetail
         content.sound = UNNotificationSound.default
         
         // notification's trigger
         let dateComponents = Calendar.current.dateComponents(
             [.weekday, .hour, .minute],
             from: todo.wrappedReminderDate
         )
         
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: todo.repeatReminder)
         
         // notification's request
         let request = UNNotificationRequest(
             identifier: todo.id?.uuidString ?? UUID().uuidString,
             content: content,
             trigger: trigger
         )
         
         // notification added
         userNotifications.add(request) { error in
             if let error = error {
                 print("Failed to add notification.\n\(error)")
             }
         }
        print("added new notification")
     }
}
