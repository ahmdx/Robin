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

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
internal class NotificationsScheduler: RobinScheduler {
    fileprivate let center: RobinNotificationCenter
    
    init(center: RobinNotificationCenter = UNUserNotificationCenter.current()) {
        self.center = center
    }
    
    func schedule(notification: RobinNotification) -> RobinNotification? {
        if notification.scheduled == true {
            return notification
        }
        
        if (!containsFreeSlots()) {
            return nil
        }
        
        let request = notification.notificationRequest()
        
        center.add(request)
        
        notification.scheduled = true
        
        return notification
    }
    
    func schedule(group: RobinNotificationGroup) -> RobinNotificationGroup? {
        let notifications = group.notifications
        
        if (self.freeSlotsCount() < notifications.count) {
            return nil
        }
        
        notifications.forEach { _ = schedule(notification: $0) }
        
        return group
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
    
    func cancel(group: RobinNotificationGroup) {
        cancel(groupWithIdentifier: group.identifier)
    }
    
    func cancel(withIdentifier identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancel(groupWithIdentifier identifier: String) {
        let notifications = self.scheduled()
        
        let group = notifications.filter { $0.threadIdentifier == identifier }
        group.forEach { self.cancel(notification: $0) }
    }
    
    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
    
    func notification(withIdentifier identifier: String) -> RobinNotification? {
        let notifications = self.scheduled()
        
        return notifications.first { $0.identifier == identifier }
    }
    
    func group(withIdentifier identifier: String) -> RobinNotificationGroup? {
        let notifications = self.scheduled()
            .filter { $0.threadIdentifier == identifier }
        
        guard notifications.count > 0 else {
            return nil
        }
        
        return RobinNotificationGroup(notifications: notifications, identifier: identifier)
    }
    
    func scheduled() -> [RobinNotification] {
        let semaphore = DispatchSemaphore(value: 0)
        var notifications: [RobinNotification] = []
        
        center.getPendingNotificationRequests { requests in
            notifications = requests.map { $0.robinNotification() }
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return notifications
    }
    
    func scheduledCount() -> Int {
        return self.scheduled().count
    }
    
    //    MARK:- Testing
    
    func printScheduled() {
        let notifications = self.scheduled()
        
        guard notifications.count > 0 else {
            print("There are no scheduled system notifications.")
            return
        }
        
        notifications.forEach { print($0) }
    }
    
    fileprivate func freeSlotsCount() -> Int {
        return min(Constants.maximumAllowedNotifications, Constants.maximumAllowedSystemNotifications) - self.scheduledCount()
    }
    
    fileprivate func containsFreeSlots() -> Bool {
        return freeSlotsCount() > 0
    }
}
