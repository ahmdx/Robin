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

/// The maximum allowed notifications to be scheduled at a time by iOS.
///- Important: Do not change this value. Changing this value to be over
/// 64 will cause some notifications to be discarded by iOS.
internal let MAX_ALLOWED_NOTIFICATIONS = 64

public class Robin {
    private static let instance: Robin = Robin()
    public static var shared: Robin {
        return self.instance
    }
    
    private var scheduler: Scheduler!
    
    /// The maximum number of allowed notifications to be scheduled. Four slots
    /// are reserved if you would like to schedule notifications without them being dropped
    /// due to unavialable notification slots.
    ///> Feel free to change this value.
    ///- Attention: iOS by default allows a maximum of 64 notifications to be scheduled
    /// at a time.
    ///- seealso: `MAX_ALLOWED_NOTIFICATIONS`
    public static let maximumAllowedNotifications = 60
    
    private init () {
        if #available(iOS 10, *) {
            self.scheduler = UserNotificationsScheduler()
        } else {
            self.scheduler = UILocalNotificationScheduler()
        }
    }
    
    /// Requests and registers your preferred options for notifying the user.
    /// The method requests (Badge, Sound, Alert) options by default.
    ///
    /// - Parameter options: The notification options that your app requires.
    public func requestAuthorization(forOptions options: RobinAuthorizationOptions = [.badge, .sound, .alert]) {
        self.scheduler.requestAuthorization(forOptions: options)
    }
    
    /// Schedules the passed `RobinNotification` if and only if there is an available notification slot and it is not already scheduled. The number of available slots is governed by `Robin.maximumAllowedNotifications` and `Robin.MAX_ALLOWED_NOTIFICATIONS`.
    ///
    /// - Attention: iOS will discard notifications having the exact same attribute values (i.e if two notifications have the same attributes, iOS will only schedule one of them).
    ///
    /// - Parameter notification: The notification to schedule.
    /// - Returns: The scheduled `RobinNotification` if it was successfully scheduled, nil otherwise.
    public func schedule(notification: RobinNotification) -> RobinNotification? {
        return scheduler.schedule(notification: notification)
    }
    
    /// Reschedules the passed `RobinNotification` whether it is already scheduled or not. This simply cancels the `RobinNotification` and schedules it again.
    ///
    /// - Parameter notification: The notification to reschedule.
    /// - Returns: The rescheduled `RobinNotification` if it was successfully rescheduled, nil otherwise.
    public func reschedule(notification: RobinNotification) -> RobinNotification? {
        return scheduler.reschedule(notification: notification)
    }
    
    /// Cancels the passed notification if it is scheduled. If multiple notifications have identical identifiers, they will be cancelled as well.
    ///
    /// - Parameter notification: The notification to cancel.
    public func cancel(notification: RobinNotification) {
        self.scheduler.cancel(notification: notification)
    }
    
    /// Cancels all scheduled notifications having the passed identifier.
    ///
    /// - Attention: If you hold references to notifications having this same identifier, use `cancel(notification:)` instead.
    ///
    /// - Parameter identifier: The identifier to match against scheduled system notifications to cancel.
    public func cancel(withIdentifier identifier: String) {
        self.scheduler.cancel(withIdentifier: identifier)
    }
    
    /// Cancels all scheduled system notifications.
    public func cancelAll() {
        self.scheduler.cancelAll()
    }
    
    /// Returns a `RobinNotification` instance from a scheduled system notification that has an identifier matching the passed identifier.
    ///
    /// - Attention: Having a reference to a `RobinNotification` instance is the same as having multiple references to several `RobinNotification` instances with the same identifier. This is only the case when canceling notifications.
    ///
    /// - Parameter identifier: The identifier to match against a scheduled system notification.
    /// - Returns: The `RobinNotification` created from a system notification
    public func notification(withIdentifier identifier: String) -> RobinNotification? {
        return self.scheduler.notification(withIdentifier: identifier)
    }
    
    /// Returns the count of the scheduled notifications by iOS.
    ///
    /// - Returns: The count of the scheduled notifications by iOS.
    public func scheduledCount() -> Int {
        return self.scheduler.scheduledCount()
    }
    
//    MARK:- Testing
    
    /// Use this method for development and testing.
    ///> Prints all scheduled system notifications.
    ///> You can freely modifiy it without worrying about affecting any functionality.
    public func printScheduled() {
        self.scheduler.printScheduled()
    }
}
