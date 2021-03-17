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
protocol RobinNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    /// Returns the app's notifications settings.
    ///
    /// - note:
    /// Normally, the block would take `UNNotificationSettings` as its parameter, however, since it cannot be instantiated for testing, `SystemNotificationSettings`
    /// was used for that purpose.
    ///
    /// - Parameter completionHandler: A block that executes with the app's notifications settings.
    func getSettings(completionHandler: @escaping (SystemNotificationSettings) -> Void)
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
    
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void)
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    func removeAllPendingNotificationRequests()
    
    /// Returns a list of the delivered notifications that are displayed in the notification center.
    ///
    /// - note:
    /// Normally, the block would take `UNNotification` as its parameter, however, since it cannot be instantiated for testing, `DeliveredSystemNotification`
    /// was used for that purpose.
    ///
    /// - Parameter completionHandler: A block that executes with an array of the notifications. The array is empty if no notifications are currently displayed.
    func getDelivered(completionHandler: @escaping ([DeliveredSystemNotification]) -> Void)
    func removeDeliveredNotifications(withIdentifiers identifiers: [String])
    func removeAllDeliveredNotifications()
}

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
extension RobinNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions = [], completionHandler: @escaping (Bool, Error?) -> Void) {
        requestAuthorization(options: options, completionHandler: completionHandler)
    }
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)? = nil) {
        add(request, withCompletionHandler: completionHandler)
    }
}
