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
public protocol RobinSettingsManager {
    /// The alert style of the app's notifications.
    var alertStyle: UNAlertStyle { get }
    /// The authorization status of the app's notifications.
    var authorizationStatus: UNAuthorizationStatus { get }
    /// The enabled settings of the app's notifications.
    var enabledSettings: RobinSettingsOptions { get }
    
    /// The show previews status of the app's notifications.
    @available(iOS 11.0, *)
    var showPreviews: UNShowPreviewsSetting { get }
    
    /// Requests and registers your preferred options for notifying the user.
    ///
    /// - Parameter options: The notification options that your app requires.
    func requestAuthorization(forOptions options: UNAuthorizationOptions, completionHandler: (@escaping (Bool, Error?) -> Void))
    
    /// Robin automatically updates information about the app's settings when the app goes into an inactive state and
    /// becomes active again. `forceRefresh()` will cause Robin to update its information immediately without waiting for
    /// the app's state to change.
    func forceRefresh()
}
