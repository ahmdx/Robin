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

/// An enum that represents the repeat interval of the notification.
///
/// - none: The notification should never repeat.
/// - hour: The notification should repeat every hour.
/// - day: The notification should repeat every day.
/// - week: The notification should repeat every week.
/// - month: The notification should repeat every month.
public enum Repeats: String {
    case none  = "None"
    case hour  = "Hour"
    case day   = "Day"
    case week  = "Week"
    case month = "Month"
}

public class RobinNotification: NSObject {
    
    /// A string assigned to the notification for later access.
    fileprivate(set) public var identifier: String!
    
    /// The body string of the notification.
    public var body: String!
    
    /// The date in which the notification is set to fire on.
    public var date: Date! {
        didSet {
            self.userInfo[Constants.NotificationKeys.date] = self.date
        }
    }
    
    /// A dictionary that holds additional information.
    private(set) public var userInfo: [AnyHashable : Any]!
    
    /// The title string of the notification.
    public var title: String?                  = nil
    
    /// The number the notification should display on the app icon.
    public var badge: NSNumber?                = nil
    
    /// The sound name of the notification.
    public var sound: RobinNotificationSound   = RobinNotificationSound()
    
    /// The repeat interval of the notification.
    public var repeats: Repeats                = .none
    
    /// The status of the notification.
    internal(set) public var scheduled: Bool   = false
    
    public override var description: String {
        var result  = ""
        result += "RobinNotification: \(self.identifier!)\n"
        if let title = self.title {
            result += "\tTitle: \(title)\n"
        }
        result += "\tBody: \(self.body!)\n"
        result += "\tFires at: \(self.date!)\n"
        result += "\tUser info: \(self.userInfo!)\n"
        if let badge = self.badge {
            result += "\tBadge: \(badge)\n"
        }
        result += "\tSound name: \(self.sound)\n"
        result += "\tRepeats every: \(self.repeats.rawValue)\n"
        result += "\tScheduled: \(self.scheduled)"
        
        return result
    }
    
    public init(identifier: String = UUID().uuidString, body: String, date: Date = Date().next(hours: 1)) {
        self.identifier = identifier
        self.body = body
        self.date = date
        self.userInfo = [
            Constants.NotificationKeys.identifier : self.identifier,
            Constants.NotificationKeys.date : self.date
        ]
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

public func ==(lhs: RobinNotification, rhs: RobinNotification) -> Bool {
    return lhs.identifier == rhs.identifier
}

public func <(lhs: RobinNotification, rhs: RobinNotification) -> Bool {
    return lhs.date.compare(rhs.date) == ComparisonResult.orderedAscending
}
