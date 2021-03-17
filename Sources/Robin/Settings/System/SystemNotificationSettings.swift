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
internal protocol SystemNotificationSettings {
    var authorizationStatus: UNAuthorizationStatus { get }
    
    #if !os(watchOS)
    var alertStyle: UNAlertStyle { get }
    
    @available(iOS 11.0, *)
    var showPreviewsSetting: UNShowPreviewsSetting { get }
    
    var badgeSetting: UNNotificationSetting { get }
    var lockScreenSetting: UNNotificationSetting { get }
    #endif
    
    var soundSetting: UNNotificationSetting { get }
    var alertSetting: UNNotificationSetting { get }
    var notificationCenterSetting: UNNotificationSetting { get }
    
    @available(iOS 12.0, watchOS 5.0, *)
    var criticalAlertSetting: UNNotificationSetting { get }
    
    #if !os(macOS)
    #if !os(watchOS)
    var carPlaySetting: UNNotificationSetting { get }
    #endif
    
    @available(iOS 13.0, watchOS 6.0, *)
    var announcementSetting: UNNotificationSetting { get }
    #endif
    
    func getEnabledSettings() -> RobinSettingsOptions
    func robinNotificationSettings() -> RobinNotificationSettings
}

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
internal extension SystemNotificationSettings {
    func getEnabledSettings() -> RobinSettingsOptions {
        var enabledSettings: RobinSettingsOptions = []
        
        #if !os(watchOS)
        if self.badgeSetting == .enabled {
            enabledSettings.insert(.badge)
        }
        
        if self.lockScreenSetting == .enabled {
            enabledSettings.insert(.lockScreen)
        }
        #endif
        
        if self.soundSetting == .enabled {
            enabledSettings.insert(.sound)
        }
        
        if self.alertSetting == .enabled {
            enabledSettings.insert(.alert)
        }
        
        if self.notificationCenterSetting == .enabled {
            enabledSettings.insert(.notificationCenter)
        }
        
        if #available(iOS 12.0, watchOS 5.0, *) {
            if self.criticalAlertSetting == .enabled {
                enabledSettings.insert(.criticalAlert)
            }
        }
        
        #if !os(macOS)
        #if !os(watchOS)
        if self.carPlaySetting == .enabled {
            enabledSettings.insert(.carPlay)
        }
        #endif
        
        if #available(iOS 13.0, watchOS 6.0, *) {
            if self.announcementSetting == .enabled {
                enabledSettings.insert(.announcement)
            }
        }
        #endif
        
        return enabledSettings
    }
    
    func robinNotificationSettings() -> RobinNotificationSettings {
        #if os(watchOS)
        return RobinNotificationSettings(authorizationStatus: self.authorizationStatus,
                                         enabledSettings: self.getEnabledSettings())
        #else
        var settings = RobinNotificationSettings(alertStyle: self.alertStyle,
                                                 authorizationStatus: self.authorizationStatus,
                                                 enabledSettings: self.getEnabledSettings())
        if #available(iOS 11.0, *) {
            settings._showPreviews = self.showPreviewsSetting
        }
        
        return settings
        #endif
    }
}
