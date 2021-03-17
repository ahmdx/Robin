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
    /// iOS will discard notifications having the exact same attribute values (i.e if two notifications have the same attributes, iOS will only schedule one of them).
    ///
    /// - Parameter notification: The notification to schedule.
    /// - Returns: The scheduled `RobinNotification` if it was successfully scheduled, nil otherwise.
    func schedule(notification: RobinNotification) -> RobinNotification?
    
    /// Reschedules the passed `RobinNotification` whether it is already scheduled or not. This simply cancels the `RobinNotification` and schedules it again.
    ///
    /// - Parameter notification: The notification to reschedule.
    /// - Returns: The rescheduled `RobinNotification` if it was successfully rescheduled, nil otherwise.
    func reschedule(notification: RobinNotification) -> RobinNotification?
    
    /// Cancels the passed notification if it is scheduled. If multiple notifications have identical identifiers, they will be cancelled as well.
    ///
    /// - Parameter notification: The notification to cancel.
    func cancel(notification: RobinNotification)
    
    /// Cancels all scheduled notifications having the passed identifier.
    /// - attention:
    /// If you hold references to notifications having this same identifier, use `cancel(notification:)` instead.
    ///
    /// - Parameter identifier: The identifier to match against scheduled notifications to cancel.
    func cancel(withIdentifier identifier: String)
    
    /// Cancels all scheduled system notifications.
    func cancelAll()
    
    /// Returns a `RobinNotification` instance from a scheduled system notification that has an identifier matching the passed identifier.
    ///
    /// - attention:
    /// Having a reference to a `RobinNotification` instance is the same as having multiple references to several `RobinNotification` instances with the same identifier. This is only the case when canceling notifications.
    ///
    /// - Parameter identifier: The identifier to match against a scheduled system notification.
    /// - Returns: The `RobinNotification` created from a system notification
    func notification(withIdentifier identifier: String) -> RobinNotification?
    
    /// Returns the count of the scheduled notifications by iOS.
    ///
    /// - Returns: The count of the scheduled notifications by iOS.
    func scheduledCount() -> Int
    
//    MARK:- Testing
    
    /// Use this method for development and testing.
    ///> Prints all scheduled system notifications.
    ///> You can freely modify it without worrying about affecting any functionality.
    func printScheduled()
}
