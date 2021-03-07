//
// Copyright (c) 2017 Ahmed Mohamed <dev@ahmd.pro>
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

import UserNotifications

@available(iOS 10.0, macOS 10.14, *)
internal class UserNotificationsScheduler: RobinScheduler {
    fileprivate let center: RobinNotificationCenter
    
    init(center: RobinNotificationCenter = UNUserNotificationCenter.current()) {
        self.center = center
    }
    
    func requestAuthorization(forOptions options: RobinAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        let authorizationOptions: UNAuthorizationOptions = UNAuthorizationOptions(rawValue: options.rawValue)
        
        center.requestAuthorization(options: authorizationOptions, completionHandler: completionHandler)
    }
    
    func schedule(notification: RobinNotification) -> RobinNotification? {
        if notification.scheduled == true {
            return notification
        }
        
        if (self.scheduledCount() >= min(Constants.maximumAllowedNotifications, Constants.maximumAllowedSystemNotifications)) {
            return nil
        }
        
        let content = UNMutableNotificationContent()
        
        if let title = notification.title {
            content.title = title
        }
        
        content.body = notification.body
        
        var sound: UNNotificationSound = UNNotificationSound.default
        if let name = notification.sound.name {
            if name != Constants.NotificationValues.defaultSoundName {
                sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: name))
            }
        } else {
            if let notificationSound = notification.sound.sound as? UNNotificationSound {
                sound = notificationSound
            }
        }
        content.sound = sound
        
        content.userInfo = notification.userInfo
        
        content.badge = notification.badge
        
        let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(date: notification.date, repeats: notification.repeats)
        
        let request: UNNotificationRequest = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)
        center.add(request)
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
        
        center.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        notification.scheduled = false
    }
    
    func cancel(withIdentifier identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
    
    func notification(withIdentifier identifier: String) -> RobinNotification? {
        let semaphore = DispatchSemaphore(value: 0)
        var notification: RobinNotification? = nil
        
        center.getPendingNotificationRequests { requests in
            for request in requests {
                if request.identifier == identifier {
                    notification = RobinNotification.notification(withSystemNotification: request)
                    
                    semaphore.signal()
                    
                    break
                }
            }
            semaphore.signal()
        }
        
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return notification
    }
    
    func scheduledCount() -> Int {
        let semaphore = DispatchSemaphore(value: 0)
        var count: Int = 0
        
        center.getPendingNotificationRequests { requests in
            count = requests.count
            semaphore.signal()
        }
        
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return count
    }
    
    //    MARK:- Testing
    
    func printScheduled() {
        if (self.scheduledCount() == 0) {
            print("There are no scheduled system notifications.")
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        center.getPendingNotificationRequests { requests in
            for request in requests {
                let notification: RobinNotification = request.robinNotification()!
                
                print(notification)
            }
            semaphore.signal()
        }
        
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
