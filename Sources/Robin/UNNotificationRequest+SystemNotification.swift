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
extension UNNotificationRequest: SystemNotification {
    public func robinNotification() -> RobinNotification? {
        let content = self.content
        
        let notification           = RobinNotification(identifier: self.identifier, body: content.body, date: Date())
        
        let userInfo = content.userInfo
        for (key, value) in userInfo {
            notification.setUserInfo(value: value, forKey: key)
        }
        
        if content.title.trimmingCharacters(in: .whitespaces).count > 0 {
            notification.title     = content.title
        }
        
        if let trigger = self.trigger as? UNCalendarNotificationTrigger {
            var date: Date?
            if let originalDate    = notification.userInfo[Constants.NotificationKeys.date] as? Date {
                date               = originalDate
            }
            notification.repeats   = RobinNotificationRepeats.from(dateComponents: trigger.dateComponents)
            notification.date(fromDateComponents: trigger.dateComponents, repeats: notification.repeats, originalDate: date)
        }
        
        notification.badge         = content.badge

        if let sound = content.sound {
            if sound != UNNotificationSound.default {
                notification.sound = RobinNotificationSound(sound: sound)
            }
        }
        
        notification.scheduled     = true
        
        return notification
    }
}
