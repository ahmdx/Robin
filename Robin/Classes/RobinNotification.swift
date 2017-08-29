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

/// An enum that represents the repeat interval of the notification.
///
/// - none: The notification should never repeat.
/// - hour: The notification should repeat every hour.
/// - day: The notification should repeat every day.
/// - week: The notification should repeat every week.
/// - month: The notification should repeat every month.
public enum Repeats {
    case none
    case hour
    case day
    case week
    case month
}

public class RobinNotification {
    
    /// A string assigned to the notification for later access.
    fileprivate(set) public var identifier: String!
    
    /// The body string of the notification.
    public var body: String!
    
    /// The date in which the notification is set to fire on.
    public var date: Date!
    
    /// A dictionary that holds additional information.
    private(set) public var userInfo: [AnyHashable : Any]!
    
    /// The title string of the notification.
    public var title: String?                  = nil
    
    /// The number the notification should display on the app icon.
    public var badge: NSNumber?                = nil
    
    /// The sound name of the notification.
    public var sound: String                   = RobinNotification.defaultSoundName
    
    /// The repeat interval of the notification.
    public var repeats: Repeats                = .none
    
    /// The status of the notification.
    internal(set) public var scheduled: Bool   = false
    
    /// A key that holds the identifier of the notification for UILocalNotification which is stored in the `userInfo` property.
    public static let identifierKey: String    = "RobinNotificationIdentifierKey"
    
    /// A key used to represent iOS default notification sound name.
    public static let defaultSoundName: String = "RobinNotificationDefaultSound"
    
    public init(identifier: String = UUID().uuidString, body: String, date: Date = Date().next(hours: 1)) {
        self.identifier = identifier
        self.body = body
        self.date = date
        self.userInfo = [RobinNotification.identifierKey : self.identifier]
    }
    
    /// Adds a value to the specified key in the `userInfo` property. Note that the value is not added if the key is equal to the `identifierKey`.
    ///
    /// - Parameters:
    ///   - value: The value to set.
    ///   - key: The key to set the value of.
    public func setUserInfo(value: Any, forKey key: AnyHashable) {
        if let keyString = key as? String {
            if (keyString == RobinNotification.identifierKey) {
                return
            }
        }
        self.userInfo[key] = value;
    }
    
    /// Removes the value of the specified key. Note that the value is not removed if the key is equal to the `identifierKey`.
    ///
    /// - Parameter key: The key to remove the value of.
    public func removeUserInfoValue(forKey key: AnyHashable) {
        if let keyString = key as? String {
            if (keyString == RobinNotification.identifierKey) {
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
