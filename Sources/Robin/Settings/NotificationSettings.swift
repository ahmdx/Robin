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
#if !os(macOS)
import UIKit
#else
import AppKit
#endif

@available(iOS 10.0, macOS 10.14, *)
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
    
    var alertStyle: UNAlertStyle {
        return self.settings.alertStyle
    }
    
    @available(iOS 11.0, *)
    var showPreviews: UNShowPreviewsSetting {
        return self.settings.showPreviews
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    init(center: RobinNotificationCenter = UNUserNotificationCenter.current()) {
        self.center = center
        self.settings = RobinNotificationSettings(alertStyle: .none, authorizationStatus: .notDetermined, enabledSettings: [])
        
        #if !os(macOS)
        self.observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.setSettings()
        }
        #else
        self.observer = NotificationCenter.default.addObserver(forName: NSApplication.willBecomeActiveNotification, object: nil, queue: .main) { [unowned self] notification in
            self.setSettings()
        }
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
