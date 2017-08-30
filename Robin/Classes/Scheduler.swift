//
//  Scheduler.swift
//  Pods
//
//  Created by Ahmed Mohamed on 8/26/17.
//
//

import Foundation

internal protocol Scheduler: class {
    
    /// Requests and registers your preferred options for notifying the user.
    /// The method requests (Badge, Sound, Alert) options by default.
    ///
    /// - Parameter options: The notification options that your app requires.
    func requestAuthorization(forOptions options: RobinAuthorizationOptions)
    
    /// Schedules the passed notification if and only if there is an available notification slot and it is not already scheduled. The number of available slots is governed by `Robin.maximumAllowedNotifications` and `Robin.MAX_ALLOWED_NOTIFICATIONS`.
    ///
    /// - Attention: iOS will discard notifications having the exact same attribute values (i.e if two notifications have the same attributes, iOS will only schedule one of them).
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
    /// - Attention: If you hold references to notifications having this same identifier, use `cancel(notification:)` instead.
    ///
    /// - Parameter identifier: The identifier to match against scheduled notifications to cancel.
    func cancel(withIdentifier identifier: String)
    
    /// Cancels all scheduled system notifications.
    func cancelAll()
    
    /// Returns a `RobinNotification` instance from a scheduled system notification that has an identifier matching the passed identifier.
    ///
    /// - Attention: Having a reference to a `RobinNotification` instance is the same as having multiple references to several `RobinNotification` instances with the same identifier. This is only the case when canceling notifications.
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
    ///> You can freely modifiy it without worrying about affecting any functionality.
    func printScheduled()
}
