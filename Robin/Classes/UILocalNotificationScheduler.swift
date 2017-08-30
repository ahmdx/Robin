//
// Copyright (c) 2017 Ahmed Abdelbadie <badie.ahmed@icloud.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

internal class UILocalNotificationScheduler: Scheduler {
    func requestAuthorization(forOptions options: RobinAuthorizationOptions) {
        let types: UIUserNotificationType = UIUserNotificationType(rawValue: options.rawValue)
        
        let notificationSettings = UIUserNotificationSettings(types: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    func schedule(notification: RobinNotification) -> RobinNotification? {
        if notification.scheduled == true {
            return nil
        }
        
        if (self.scheduledCount() >= Robin.maximumAllowedNotifications) {
            return nil
        }
        
        let localNotification = UILocalNotification()
        
        if #available(iOS 8.2, *) {
            localNotification.alertTitle             = notification.title
        }
        localNotification.alertBody                  = notification.body
        localNotification.fireDate                   = notification.date.removeSeconds()
        localNotification.soundName                  = (notification.sound == RobinNotification.defaultSoundName) ? UILocalNotificationDefaultSoundName : notification.sound
        localNotification.userInfo                   = notification.userInfo
        if let badge = notification.badge {
            localNotification.applicationIconBadgeNumber = badge as! Int
        }
        
        if (notification.repeats != .none) {
            switch notification.repeats {
            case .hour: localNotification.repeatInterval  = NSCalendar.Unit.hour
            case .day: localNotification.repeatInterval   = NSCalendar.Unit.day
            case .week: localNotification.repeatInterval  = NSCalendar.Unit.weekOfYear
            case .month: localNotification.repeatInterval = NSCalendar.Unit.month
            default: break
            }
        }
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
        notification.scheduled = true
        
        return notification
    }
    
    func reschedule(notification: RobinNotification) -> RobinNotification? {
        self.cancel(notification: notification)
        
        return self.schedule(notification: notification)
    }
    
    func cancel(notification: RobinNotification) {
        if notification.scheduled == false {
            return
        }
        
        guard let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications else {
            return
        }
        
        if (scheduledNotifications.count == 0) {
            return
        }
        
        for scheduledNotification in scheduledNotifications {
            if let identifier = scheduledNotification.userInfo?[RobinNotification.identifierKey] as? String {
                if identifier == notification.identifier {
                    UIApplication.shared.cancelLocalNotification(scheduledNotification)
                    
                    notification.scheduled = false
                }
            }
        }
    }
    
    func cancel(withIdentifier identifier: String) {
        guard let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications else {
            return
        }
        
        if (scheduledNotifications.count == 0) {
            return
        }
        
        for scheduledNotification in scheduledNotifications {
            if let notificationIdentifier = scheduledNotification.userInfo?[RobinNotification.identifierKey] as? String {
                if notificationIdentifier == identifier {
                    UIApplication.shared.cancelLocalNotification(scheduledNotification)
                }
            }
        }
    }
    
    func cancelAll() {
        UIApplication.shared.cancelAllLocalNotifications()
        print("All scheduled system notifications have been canceled.")
    }
    
    func notification(withIdentifier identifier: String) -> RobinNotification? {
        guard let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications else {
            return nil
        }
        
        if (scheduledNotifications.count == 0) {
            return nil
        }
        
        for scheduledNotification in scheduledNotifications {
            if let notificationIdentifier = scheduledNotification.userInfo?[RobinNotification.identifierKey] as? String {
                if notificationIdentifier == identifier {
                    return RobinNotification.notification(withSystemNotification: scheduledNotification)
                }
            }
        }
        
        return nil
    }
    
    func scheduledCount() -> Int {
        return (UIApplication.shared.scheduledLocalNotifications?.count)!
    }
    
//    MARK:- Testing
    
    func printScheduled() {
        guard let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications else {
            print("Cannot print scheduled system notifications.")
            return
        }
        
        if (scheduledNotifications.count == 0) {
            print("There are no scheduled system notifications.")
            return
        }
        
        for scheduledNotification in scheduledNotifications {
            if let notificationIdentifier = scheduledNotification.userInfo?[RobinNotification.identifierKey] as? String {
                let notification = self.notification(withIdentifier: notificationIdentifier)
                
                print(notification!)
            }
        }
    }
}
