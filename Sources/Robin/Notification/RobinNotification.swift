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

import Foundation

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public class RobinNotification: NSObject {
    
    /// A string assigned to the notification for later access.
    fileprivate(set) public var identifier: String!
    
    /// The body string of the notification.
    public var body: String!
    
    /// The trigger that causes the notification to fire.
    public var trigger: RobinNotificationTrigger! {
        didSet {
            if case .date(let date, let repeats) = trigger {
                let truncatedDate = date.truncateSeconds()

                self.trigger = .date(truncatedDate, repeats: repeats)
                self.userInfo[Constants.NotificationKeys.date] = truncatedDate
            }
        }
    }
    
    /// A dictionary that holds additional information.
    private(set) public var userInfo: [AnyHashable : Any] = [:]
    
    /// The title string of the notification.
    public var title: String? = nil
    
    /// The number the notification should display on the app icon.
    public var badge: NSNumber? = nil
    
    #if !os(watchOS)
    /// The sound name of the notification.
    public var sound: RobinNotificationSound = RobinNotificationSound()
    #endif
    
    /// The status of the notification.
    internal(set) public var scheduled: Bool = false
    
    /// The delivery status of the notification.
    internal(set) public var delivered: Bool = false
    
    /// The delivery date of the notification.
    internal(set) public var deliveryDate: Date?
    
    /// The identifier used to visually group notifications together.
    public var threadIdentifier: String?
    
    public override var description: String {
        var result = ""
        result += "RobinNotification: \(self.identifier!)\n"
        if let title = self.title {
            result += "\tTitle: \(title)\n"
        }
        if let threadIdentifier = threadIdentifier {
            result += "\tThread identifier: \(threadIdentifier)\n"
        }
        result += "\tBody: \(self.body!)\n"
        if case .date(let date, let repeats) = self.trigger {
            result += "\tFires at: \(date)\n"
            result += "\tRepeats every: \(repeats.rawValue)\n"
        }
        
        #if !os(macOS) && !os(watchOS)
        if case .location(let region, let repeats) = self.trigger {
            result += "\tFires around: \(region)\n"
            result += "\tRepeating: \(repeats)\n"
        }
        #endif
        
        result += "\tUser info: \(self.userInfo)\n"
        if let badge = self.badge {
            result += "\tBadge: \(badge)\n"
        }
        #if !os(watchOS)
        result += "\tSound name: \(self.sound)\n"
        #endif
        result += "\tScheduled: \(self.scheduled)\n"
        result += "\tDelivered: \(self.delivered)"
        if let deliveryDate = deliveryDate {
            result += "\n\tDelivered on: \(deliveryDate)"
        }
        
        return result
    }
    
    public convenience init(identifier: String = UUID().uuidString,
                            body: String,
                            trigger: RobinNotificationTrigger = .date(.next(hours: 1))) {
        self.init(identifier: identifier, body: body)
        
        if case .date(let date, let repeats) = trigger {
            let truncatedDate = date.truncateSeconds()

            self.trigger = .date(truncatedDate, repeats: repeats)
            self.userInfo[Constants.NotificationKeys.date] = truncatedDate
        } else {
            self.trigger = trigger
        }
    }
    
    internal init(identifier: String, body: String) {
        self.identifier = identifier
        self.body = body
        
        self.userInfo[Constants.NotificationKeys.identifier] = identifier
    }
    
    /// Creates a `RobinNotification` from the passed `SystemNotification`. For the details of the creation process, have a look at the system notifications extensions that implement the `SystemNotification` protocol.
    ///
    /// - Parameter notification: The system notification to create the `RobinNotification` from.
    /// - Returns: The `RobinNotification` if the creation succeeded, nil otherwise.
    public static func notification(withSystemNotification notification: SystemNotification) -> RobinNotification? {
        return notification.robinNotification()
    }
    
    /// Adds a value to the specified key in the `userInfo` property. Note that the value is not added if the key is equal to the `identifierKey` or `dateKey`.
    ///
    /// - Parameters:
    ///   - value: The value to set.
    ///   - key: The key to set the value of.
    public func setUserInfo(value: Any, forKey key: AnyHashable) {
        if let keyString = key as? String {
            if (keyString == Constants.NotificationKeys.identifier || keyString == Constants.NotificationKeys.date) {
                return
            }
        }
        self.userInfo[key] = value;
    }
    
    /// Removes the value of the specified key. Note that the value is not removed if the key is equal to the `identifierKey` or `dateKey`.
    ///
    /// - Parameter key: The key to remove the value of.
    public func removeUserInfoValue(forKey key: AnyHashable) {
        if let keyString = key as? String {
            if (keyString == Constants.NotificationKeys.identifier || keyString == Constants.NotificationKeys.date) {
                return
            }
        }
        self.userInfo.removeValue(forKey: key)
    }
}
