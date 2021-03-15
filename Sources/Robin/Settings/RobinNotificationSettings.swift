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

/// A struct that holds information about the app's notifications settings.
@available(iOS 10.0, macOS 10.14, *)
public struct RobinNotificationSettings {
    public let alertStyle: UNAlertStyle
    public let authorizationStatus: UNAuthorizationStatus
    public let enabledSettings: RobinSettingsOptions
    
    internal var _showPreviews: Any? = nil {
        // Makes sure the variable is set to a non-nil value exactly once.
        didSet {
            _showPreviews = oldValue ?? _showPreviews
        }
    }
    
    @available(iOS 11.0, *)
    public var showPreviews: UNShowPreviewsSetting {
        return _showPreviews as? UNShowPreviewsSetting ?? .never
    }
    
    internal init(alertStyle: UNAlertStyle,
                  authorizationStatus: UNAuthorizationStatus,
                  enabledSettings: RobinSettingsOptions) {
        self.alertStyle = alertStyle
        self.authorizationStatus = authorizationStatus
        self.enabledSettings = enabledSettings
    }
}
