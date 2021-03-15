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

import Foundation
import XCTest
@testable import Robin
import UserNotifications
#if !os(macOS)
import UIKit
#else
import AppKit
#endif

@available(iOS 10.0, macOS 10.14, *)
class RobinSettingsTests: XCTestCase {
    fileprivate static let center = RobinNotificationCenterMock()
    
    override class func setUp() {
        Robin.notificationsSettings = NotificationSettings(center: center)
    }
    
    override func tearDown() {
        // Reset notification settings.
        RobinSettingsTests.center.settings = SystemNotificationSettingsMock()
        Robin.settings.forceRefresh()
    }
    
    /// Tests whether requesting authorization succeeds.
    func testRequestAuthorization() {
        let expectation = XCTestExpectation()
        
        Robin.settings.requestAuthorization(forOptions: [.alert]) { grant, error in
            XCTAssertTrue(grant)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Tests whether retrieving notification settings succeeds.
    func testGetNotificationsSettings() {
        let settings = Robin.settings
        
        XCTAssertEqual(settings.alertStyle, .none)
        XCTAssertEqual(settings.authorizationStatus, .notDetermined)
        
        if #available(iOS 11.0, *) {
            XCTAssertEqual(settings.showPreviews, .never)
        }
        
        XCTAssertEqual(settings.enabledSettings, [])
    }
    
    func testUpdateSettingsWithForceRefresh() {
        let settings = Robin.settings
        
        XCTAssertEqual(settings.alertStyle, .none)
        XCTAssertEqual(settings.authorizationStatus, .notDetermined)
        
        if #available(iOS 11.0, *) {
            XCTAssertEqual(settings.showPreviews, .never)
        }
        
        XCTAssertEqual(settings.enabledSettings, [])
        
        let centerSettings = RobinSettingsTests.center.settings
        
        centerSettings.alertStyle = .alert
        centerSettings.authorizationStatus = .authorized
        
        if #available(iOS 11.0, *) {
            centerSettings._showPreviewsSetting = UNShowPreviewsSetting.whenAuthenticated
        }
        
        centerSettings.badgeSetting = .enabled
        centerSettings.soundSetting = .enabled
        centerSettings.alertSetting = .enabled
        centerSettings.notificationCenterSetting = .enabled
        centerSettings.lockScreenSetting = .enabled
        centerSettings.criticalAlertSetting = .enabled
        centerSettings.announcementSetting = .enabled
        centerSettings.carPlaySetting = .enabled
        
        settings.forceRefresh()
        
        XCTAssertEqual(settings.alertStyle, .alert)
        XCTAssertEqual(settings.authorizationStatus, .authorized)
        
        // Available on both iOS 10.0+ and macOS 10.14+
        let baseEnabledSettings: RobinSettingsOptions = [.badge, .sound, .alert, .notificationCenter, .lockScreen]
        
        if #available(iOS 11.0, *) {
            XCTAssertEqual(settings.showPreviews, .whenAuthenticated)
        }
        
        XCTAssertTrue(settings.enabledSettings.contains(baseEnabledSettings))
        
        // iOS 12.0+ and macOS 10.14+
        if #available(iOS 12.0, *) {
            XCTAssertTrue(settings.enabledSettings.contains(.criticalAlert))
        }
        
        #if !os(macOS)
        // iOS 10.0+ only
        XCTAssertTrue(settings.enabledSettings.contains(.carPlay))
        
        if #available(iOS 13.0, *) {
            XCTAssertTrue(settings.enabledSettings.contains(.announcement))
        }
        #endif
    }
    
    func testUpdateSettingsWithNotifications() {
        let settings = Robin.settings
        
        XCTAssertEqual(settings.alertStyle, .none)
        XCTAssertEqual(settings.authorizationStatus, .notDetermined)
        
        if #available(iOS 11.0, *) {
            XCTAssertEqual(settings.showPreviews, .never)
        }
        
        XCTAssertEqual(settings.enabledSettings, [])
        
        let centerSettings = RobinSettingsTests.center.settings
        
        centerSettings.alertStyle = .alert
        centerSettings.authorizationStatus = .authorized
        
        if #available(iOS 11.0, *) {
            centerSettings._showPreviewsSetting = UNShowPreviewsSetting.whenAuthenticated
        }
        
        centerSettings.badgeSetting = .enabled
        centerSettings.soundSetting = .enabled
        centerSettings.alertSetting = .enabled
        centerSettings.notificationCenterSetting = .enabled
        centerSettings.lockScreenSetting = .enabled
        centerSettings.criticalAlertSetting = .enabled
        centerSettings.announcementSetting = .enabled
        centerSettings.carPlaySetting = .enabled
        
        let notificationCenter = NotificationCenter.default
        
        // Send application lifecycle notification
        #if !os(macOS)
        notificationCenter.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        #else
        notificationCenter.post(name: NSApplication.willBecomeActiveNotification, object: nil)
        #endif
        
        XCTAssertEqual(settings.alertStyle, .alert)
        XCTAssertEqual(settings.authorizationStatus, .authorized)
        
        // Available on both iOS 10.0+ and macOS 10.14+
        let baseEnabledSettings: RobinSettingsOptions = [.badge, .sound, .alert, .notificationCenter, .lockScreen]
        
        if #available(iOS 11.0, *) {
            XCTAssertEqual(settings.showPreviews, .whenAuthenticated)
        }
        
        XCTAssertTrue(settings.enabledSettings.contains(baseEnabledSettings))
        
        // iOS 12.0+ and macOS 10.14+
        if #available(iOS 12.0, *) {
            XCTAssertTrue(settings.enabledSettings.contains(.criticalAlert))
        }
        
        #if !os(macOS)
        // iOS 10.0+ only
        XCTAssertTrue(settings.enabledSettings.contains(.carPlay))
        
        if #available(iOS 13.0, *) {
            XCTAssertTrue(settings.enabledSettings.contains(.announcement))
        }
        #endif
    }
}
