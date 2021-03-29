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
internal extension RobinNotification {
    /// Transforms an instance of `RobinNotification` to an instance of `UNNotificationRequest`.
    ///
    /// - Returns: A `UNNotificationRequest` from the the `RobinNotification` instance.
    func notificationRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        
        if let title = self.title {
            content.title = title
        }
        
        content.body = self.body
        
        var sound: UNNotificationSound = UNNotificationSound.default
        #if !os(watchOS)
        if let name = self.sound.name {
            if name != Constants.NotificationValues.defaultSoundName {
                sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: name))
            }
        } else {
            if let notificationSound = self.sound.sound as? UNNotificationSound {
                sound = notificationSound
            }
        }
        #endif
        content.sound = sound
        
        content.userInfo = self.userInfo
        
        content.badge = self.badge
        
        if let threadIdentifier = self.threadIdentifier {
            content.threadIdentifier = threadIdentifier
        }
        
        if let categoryIdentifier = self.categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        
        var notificationTrigger: UNNotificationTrigger!
        
        if let trigger = trigger,
           case let RobinNotificationTrigger.date(date, repeats) = trigger {
            notificationTrigger = UNCalendarNotificationTrigger(date: date, repeats: repeats)
        }
        
        if let trigger = trigger,
           case let RobinNotificationTrigger.interval(interval, repeats) = trigger {
            notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        }
        
        #if !os(macOS) && !os(watchOS)
        if let trigger = trigger,
           case let RobinNotificationTrigger.location(region, repeats) = trigger {
            notificationTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        }
        #endif
        
        let request = UNNotificationRequest(identifier: self.identifier, content: content, trigger: notificationTrigger)
        
        return request
    }
}
