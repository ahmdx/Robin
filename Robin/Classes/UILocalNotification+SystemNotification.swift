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

extension UILocalNotification: SystemNotification {
    
    /// Creates a `RobinNotification` from the `UILocalNotification` instance. For the creation to succeed, the `UILocalNotification` instance's `userInfo` property should contain a key, see `RobinNotification.identifierKey`, with a string value as the identifier.
    ///
    /// - Returns: The `RobinNotification` if the creation succeeded, nil otherwise.
    public func robinNotification() -> RobinNotification? {
        guard let userInfo = self.userInfo, let identifier = userInfo[RobinNotification.identifierKey] as? String else {
            return nil
        }
        
        let notification           = RobinNotification(identifier: identifier, body: self.alertBody!, date: self.fireDate!)
        
        for (key, value) in userInfo {
            notification.setUserInfo(value: value, forKey: key)
        }
        if #available(iOS 8.2, *) {
            notification.title     = self.alertTitle
        }
        notification.badge         = self.applicationIconBadgeNumber as NSNumber
        if self.soundName != UILocalNotificationDefaultSoundName {
            if let soundName       = self.soundName {
                notification.sound = soundName
            }
        }
        
        var repeats: Repeats
        switch self.repeatInterval {
        case NSCalendar.Unit.hour:
            repeats                = .hour
        case NSCalendar.Unit.day:
            repeats                = .day
        case NSCalendar.Unit.weekOfYear:
            repeats                = .week
        case NSCalendar.Unit.month:
            repeats                = .month
        default: repeats           = .none
        }
        
        notification.repeats       = repeats
        notification.scheduled     = true
        
        return notification
    }
}
