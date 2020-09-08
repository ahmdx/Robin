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

import UserNotifications

@available(iOS 10.0, *)
internal class UserNotificationsScheduler: Scheduler {    
    func requestAuthorization(forOptions options: RobinAuthorizationOptions) {
        let center: UNUserNotificationCenter             = UNUserNotificationCenter.current()
        let authorizationOptions: UNAuthorizationOptions = UNAuthorizationOptions(rawValue: options.rawValue)
        
        center.requestAuthorization(options: authorizationOptions) { (granter, error) in }
    }
    
    private func trigger(forDate date: Date, repeats: Repeats) -> UNCalendarNotificationTrigger {
        var dateComponents: DateComponents = DateComponents()
        let shouldRepeat: Bool             = repeats != .none
        let calendar: Calendar             = Calendar.current
        
        switch repeats {
        case .none:
            dateComponents                 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        case .month:
            dateComponents                 = calendar.dateComponents([.day, .hour, .minute], from: date)
        case .week:
            dateComponents.weekday         = calendar.component(.weekday, from: date)
            fallthrough
        case .day:
            dateComponents.hour            = calendar.component(.hour, from: date)
            fallthrough
        case .hour:
            dateComponents.minute          = calendar.component(.minute, from: date)
            dateComponents.second          = 0
        }
        
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: shouldRepeat)
    }
    
    func schedule(notification: RobinNotification) -> RobinNotification? {
        if notification.scheduled == true {
            return nil
        }
        
        if (self.scheduledCount() >= Robin.maximumAllowedNotifications) {
            return nil
        }
        
        let content                                = UNMutableNotificationContent()
        
        if let title                               = notification.title {
            content.title                          = title
        }
        
        content.body                               = notification.body
        
        var sound: UNNotificationSound             = UNNotificationSound.default
        if let name = notification.sound.name {
            if name != RobinNotification.defaultSoundName {
                sound                              = UNNotificationSound(named: UNNotificationSoundName(rawValue: name))
            }
        } else {
            if let notificationSound = notification.sound.sound as? UNNotificationSound {
                sound                              = notificationSound
            }
        }
        content.sound                              = sound
        
        content.userInfo                           = notification.userInfo
        
        content.badge                              = notification.badge
        
        let trigger: UNCalendarNotificationTrigger = self.trigger(forDate: notification.date, repeats: notification.repeats)
        
        let request: UNNotificationRequest         = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)
        let center: UNUserNotificationCenter       = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        notification.scheduled                     = true
        
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
        
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        notification.scheduled = false
    }
    
    func cancel(withIdentifier identifier: String) {
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAll() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("All scheduled system notifications have been canceled.")
    }
    
    func notification(withIdentifier identifier: String) -> RobinNotification? {
        let semaphore                         = DispatchSemaphore(value: 0)
        var notification: RobinNotification?  = nil
        
        let center: UNUserNotificationCenter  = UNUserNotificationCenter.current()
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
        let semaphore                        = DispatchSemaphore(value: 0)
        var count: Int                       = 0
        
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
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
        
        let semaphore                        = DispatchSemaphore(value: 0)
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
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
