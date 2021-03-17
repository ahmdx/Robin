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
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
internal class NotificationSettings: RobinSettingsManager {
    fileprivate let center: RobinNotificationCenter
    fileprivate var observer: NSObjectProtocol? = nil
    fileprivate var settings: RobinNotificationSettings
    
    var enabledSettings: RobinSettingsOptions {
        return self.settings.enabledSettings
    }
    
    var authorizationStatus: UNAuthorizationStatus {
        return self.settings.authorizationStatus
    }
    
    #if !os(watchOS)
    var alertStyle: UNAlertStyle {
        return self.settings.alertStyle
    }
    
    
    @available(iOS 11.0, *)
    var showPreviews: UNShowPreviewsSetting {
        return self.settings.showPreviews
    }
    #endif
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    init(center: RobinNotificationCenter = UNUserNotificationCenter.current()) {
        self.center = center
        #if os(watchOS)
        self.settings = RobinNotificationSettings(authorizationStatus: .notDetermined, enabledSettings: [])
        #else
        self.settings = RobinNotificationSettings(alertStyle: .none, authorizationStatus: .notDetermined, enabledSettings: [])
        #endif
        
        let notificationCenter = NotificationCenter.default
        let completionHandler: ((Notification) -> Void) = { [unowned self] notification in
            self.setSettings()
        }
        
        #if os(macOS)
        self.observer = notificationCenter.addObserver(forName: NSApplication.willBecomeActiveNotification, object: nil, queue: .main, using: completionHandler)
        #elseif os(iOS)
        self.observer = notificationCenter.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: completionHandler)
        #endif
        
        setSettings()
    }
    
    fileprivate func setSettings() {
        let semaphore = DispatchSemaphore(value: 0)
        center.getSettings { settings in
            self.settings = settings.robinNotificationSettings()
            
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    func requestAuthorization(forOptions options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        let authorizationOptions: UNAuthorizationOptions = UNAuthorizationOptions(rawValue: options.rawValue)
        
        center.requestAuthorization(options: authorizationOptions, completionHandler: completionHandler)
    }
    
    func forceRefresh() {
        setSettings()
    }
}
