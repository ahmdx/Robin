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

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public protocol RobinScheduler: class {
    /// Schedules the passed notification if and only if there is an available notification slot and it is not already scheduled. The number of available slots is governed by `Robin.maximumAllowedNotifications` and `Constants.maximumAllowedSystemNotifications`.
    ///
    /// - attention:
    /// The system will discard notifications having the exact same attribute values (i.e if two notifications have the same attributes, it will only schedule one of them).
    /// If you want to schedule multiple notifications under the same identifier, see `schedule(group: RobinNotificationGroup) -> RobinNotificationGroup?`.
    ///
    /// - Parameter notification: The notification to schedule.
    /// - Returns: The scheduled `RobinNotification` if it was successfully scheduled, nil otherwise.
    func schedule(notification: RobinNotification) -> RobinNotification?
    
    /// Schedules the passed notification group if and only if there are available notification slots and the notifications are not already scheduled. The number of available slots is governed by `Robin.maximumAllowedNotifications` and `Constants.maximumAllowedSystemNotifications`.
    ///
    /// - Parameter group: The notification group to schedule.
    /// - Returns: The scheduled `RobinNotificationGroup` if it was successfully scheduled, nil otherwise.
    func schedule(group: RobinNotificationGroup) -> RobinNotificationGroup?
    
    /// Reschedules the passed `RobinNotification` whether it is already scheduled or not. This simply cancels the `RobinNotification` and schedules it again.
    ///
    /// - Parameter notification: The notification to reschedule.
    /// - Returns: The rescheduled `RobinNotification` if it was successfully rescheduled, nil otherwise.
    func reschedule(notification: RobinNotification) -> RobinNotification?
    
    /// Cancels the passed notification if it is scheduled.
    ///
    /// - Parameter notification: The notification to cancel.
    func cancel(notification: RobinNotification)
    
    /// Cancels the passed notification group if it is scheduled.
    ///
    /// - Parameter group: The notification group to cancel.
    func cancel(group: RobinNotificationGroup)
    
    /// Cancels the scheduled notification having the passed identifier.
    ///
    /// - attention:
    /// If you hold a reference to the notification having this same identifier, use `cancel(notification: RobinNotification)` instead.
    ///
    /// - Parameter identifier: The identifier to match against scheduled notifications to cancel.
    func cancel(withIdentifier identifier: String)
    
    /// Cancels the notification group having the passed identifier.
    ///
    /// - attention:
    /// If you hold a reference to the notification group having this same identifier, use `cancel(group: RobinNotificationGroup)` instead.
    ///
    /// - Parameter identifier: The identifier to match against scheduled notifications to cancel.
    func cancel(groupWithIdentifier identifier: String)
    
    /// Cancels all scheduled system notifications.
    func cancelAll()
    
    /// Returns a `RobinNotification` instance from a scheduled system notification that has an identifier matching the passed identifier.
    ///
    /// - Parameter identifier: The identifier to match against a scheduled system notification.
    /// - Returns: The `RobinNotification` created from a system notification if it exists.
    func notification(withIdentifier identifier: String) -> RobinNotification?
    
    /// Returns a `RobinNotificationGroup` instance from the scheduled system notifications that have an `threadIdentifier` matching the passed identifier.
    ///
    /// - Parameter identifier: The identifier to match against the scheduled system notifications.
    /// - Returns: The `RobinNotificationGroup` created with the system notifications, if any exists.
    func group(withIdentifier identifier: String) -> RobinNotificationGroup?
    
    /// Returns a list of all scheduled notifications.
    ///
    /// - Returns: The list of the scheduled notifications.
    func scheduled() -> [RobinNotification]
    
    /// Returns the count of the scheduled notifications.
    ///
    /// - Returns: The count of the scheduled notifications.
    func scheduledCount() -> Int
    
//    MARK:- Testing
    
    /// Use this method for development and testing.
    ///> Prints all scheduled system notifications.
    ///> You can freely modify it without worrying about affecting any functionality.
    func printScheduled()
}
