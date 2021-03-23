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

#if !os(watchOS)
import XCTest
@testable import Robin
#if !os(macOS)
import CoreLocation
#endif

@available(iOS 10.0, macOS 10.14, *)
class RobinNotificationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Tests whether the initialization of a date `RobinNotification` succeeds.
    func testDateNotificationInitialization() {
        let body: String = "This is a test notification"
        let notification: RobinNotification = RobinNotification(body: body)
        
        // Tests body property
        XCTAssertEqual(body, notification.body)
        
        // Tests trigger property
        XCTAssertEqual(notification.trigger, .date(Date.next(hours: 1).truncateSeconds(), repeats: .none))
        let date: Date = Date().truncateSeconds()
        notification.trigger = .date(date, repeats: .month)
        XCTAssertEqual(notification.trigger, .date(date.truncateSeconds(), repeats: .month))
        
        // Tests title property
        XCTAssertNil(notification.title)
        let title: String = "Title"
        notification.title = title
        XCTAssertEqual(title, notification.title)
        
        // Tests identifier property
        XCTAssertNotNil(notification.identifier)
        
        // Tests badge property
        XCTAssertNil(notification.badge)
        let badge: NSNumber = 5
        notification.badge = badge
        XCTAssertEqual(badge, notification.badge)
        
        // Tests userInfo property
        let userInfo: [AnyHashable : Any] = [Constants.NotificationKeys.date: date]
        XCTAssertEqual(userInfo[Constants.NotificationKeys.date] as! Date, notification.userInfo[Constants.NotificationKeys.date] as! Date)
        
        // Tests sound property
        XCTAssertTrue(notification.sound.isValid())
        let sound: String = "SoundName"
        notification.sound = RobinNotificationSound(named: sound)
        XCTAssertTrue(notification.sound.isValid())
        
        // Tests scheduled property
        XCTAssertFalse(notification.scheduled)
    }
    
    /// Tests whether the initialization of an interval `RobinNotification` succeeds.
    func testIntervalNotificationInitialization() {
        let body: String = "This is a test notification"
        let notification: RobinNotification = RobinNotification(body: body, trigger: .interval(30, repeats: false))
        
        // Tests body property
        XCTAssertEqual(body, notification.body)
        
        // Tests trigger property
        XCTAssertEqual(notification.trigger, .interval(30, repeats: false))
        notification.trigger = .interval(60, repeats: true)
        XCTAssertEqual(notification.trigger, .interval(60, repeats: true))
        
        // Tests title property
        XCTAssertNil(notification.title)
        let title: String = "Title"
        notification.title = title
        XCTAssertEqual(title, notification.title)
        
        // Tests identifier property
        XCTAssertNotNil(notification.identifier)
        
        // Tests badge property
        XCTAssertNil(notification.badge)
        let badge: NSNumber = 5
        notification.badge = badge
        XCTAssertEqual(badge, notification.badge)
        
        // Tests sound property
        XCTAssertTrue(notification.sound.isValid())
        let sound: String = "SoundName"
        notification.sound = RobinNotificationSound(named: sound)
        XCTAssertTrue(notification.sound.isValid())
        
        // Tests scheduled property
        XCTAssertFalse(notification.scheduled)
    }
    
    #if !os(macOS)
    /// Tests whether the initialization of a location `RobinNotification` succeeds.
    func testLocationNotificationInitialization() {
        let body: String = "This is a test notification"
        
        /// https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger
        let center = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
        let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
        region.notifyOnEntry = true
        
        let notification: RobinNotification = RobinNotification(body: body, trigger: .location(region, repeats: false))
        
        // Tests body property
        XCTAssertEqual(body, notification.body)
        
        // Tests trigger property
        XCTAssertEqual(notification.trigger, .location(region, repeats: false))
        notification.trigger = .location(region, repeats: true)
        XCTAssertEqual(notification.trigger, .location(region, repeats: true))
        
        // Tests title property
        XCTAssertNil(notification.title)
        let title: String = "Title"
        notification.title = title
        XCTAssertEqual(title, notification.title)
        
        // Tests identifier property
        XCTAssertNotNil(notification.identifier)
        
        // Tests badge property
        XCTAssertNil(notification.badge)
        let badge: NSNumber = 5
        notification.badge = badge
        XCTAssertEqual(badge, notification.badge)
        
        // Tests sound property
        XCTAssertTrue(notification.sound.isValid())
        let sound: String = "SoundName"
        notification.sound = RobinNotificationSound(named: sound)
        XCTAssertTrue(notification.sound.isValid())
        
        // Tests scheduled property
        XCTAssertFalse(notification.scheduled)
    }
    #endif
    
    /// Tests whether the initialization of `RobinNotification` with a custom identifier succeeds.
    func testNotificationInitializationWithIdentifier() {
        let body: String = "This is a test notification"
        let identifier: String = "Identifier"
        let notification: RobinNotification = RobinNotification(identifier: identifier, body: body)
        
        XCTAssertEqual(identifier, notification.identifier)
        XCTAssertEqual(body, notification.body)
    }
    
    /// Tests whether setting a `RobinNotification` userInfo key succeeds.
    func testNotificationUserInfoSet() {
        let notification: RobinNotification = RobinNotification(body: "Notification")
        
        let key: String = "Key"
        let value: String = "Value"
        notification.setUserInfo(value: value, forKey: key)
        
        XCTAssertEqual(value, notification.userInfo[key] as! String)
    }
    
    /// Tests whether setting a `RobinNotification` userInfo key succeeds.
    func testNotificationUserInfoRemove() {
        let notification: RobinNotification = RobinNotification(body: "Notification")
        
        let key: String = "Key"
        let value: String = "Value"
        notification.setUserInfo(value: value, forKey: key)
        
        notification.removeUserInfoValue(forKey: key)
        
        XCTAssertNil(notification.userInfo[key])
    }
    
    /// Tests whether initialized RobinNotifications have different identifiers.
    func testNotificationNonEquality() {
        let firstNotification: RobinNotification = RobinNotification(body: "First Notification")
        let secondNotification: RobinNotification = RobinNotification(body: "Second Notification")
        
        let notEqual: Bool = firstNotification == secondNotification
        
        XCTAssertFalse(notEqual)
    }
    
    /// Tests whether testing for notification date precedence succeeds.
    func testNotificationDatePrecedence() {
        let firstNotification: RobinNotification = RobinNotification(body: "First Notification", trigger: .date(.next(minutes: 10), repeats: .none))
        let secondNotification: RobinNotification = RobinNotification(body: "Second Notification", trigger: .date(.next(hours: 1), repeats: .none))
        
        let precedes: Bool = firstNotification < secondNotification
        
        XCTAssertTrue(precedes)
        
        firstNotification.trigger = .date(.next(days: 1), repeats: .none)
        
        let doesNotPrecede: Bool = firstNotification < secondNotification
        
        XCTAssertFalse(doesNotPrecede)
    }
}
#endif
